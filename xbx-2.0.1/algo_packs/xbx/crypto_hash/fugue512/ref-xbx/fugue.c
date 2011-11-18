/*********************************************************
 *
 * Filename	: fugue.c
 *
 * Originator	: W. Eric Hall
 *
 * Purpose      : Reference Implementation of Fugue for
 *                224, 256, 384 and 512 bit hash sizes
 *
 *********************************************************/

#include "fugue.h"

INLINE uint32 COLUMN (hashState* hs, uint32 col)
{
    uint32 x = hs->Base+col;
    return (x<hs->Cfg->s ? x : x-hs->Cfg->s);
}

#define STATE(_s,_c)     _s->State[COLUMN(_s,_c)].d
#define BYTES(_s,_r,_c)  _s->State[COLUMN(_s,_c)].b[_r]
#define ENTRY(_s,_r,_c)  _s[_c].b[_r]
#define ROTATE(_s,_r)    _s->Base = COLUMN(_s,_s->Cfg->s-_r)

#define cdiv(_n,_d) ((_n + _d - 1) / _d)

static struct {
    int       hashbitlen;
    hashCfg   Cfg;
    uint32    IV[16];
    }         hashSizes[] = {{224,{7 ,30,2,5,13},{0}}
                            ,{256,{8 ,30,2,5,13},{0}}
                            ,{384,{12,36,3,6,13},{0}}
                            ,{512,{16,36,4,8,13},{0}}
                            ,{0}
                            };

static uint8    init_fugue = 0;
static hash32_s M[4];
static union {
    uint64   d;
    uint8    b[8];
    }           gf2mul[256];
static uint8    aessub[256];

INLINE
void
Input_Mix (hashState* hs, uint32 sc)
{
    int s = hs->Cfg->s;
    int k = hs->Cfg->k;
    int i;

    STATE (hs, 6*k-2) ^= STATE (hs, 0);
    STATE (hs, 0)      = sc;
    STATE (hs, 8)     ^= sc;
    for (i=0; i<=k-2; i++)
        STATE (hs, 3*i+1) ^= STATE (hs, s-3*k+3*i);
}

INLINE
void
ROR3_Col_Mix (hashState* hs)
{
    int s = hs->Cfg->s;
    int i;

    ROTATE (hs, 3);
    for (i=0; i<3; i++)
    {
        STATE (hs, i)     ^= STATE (hs, 4+i);
        STATE (hs, s/2+i) ^= STATE (hs, 4+i);
    }
}

INLINE
void
Col_Xor (hashState* hs, int a, int b, int c)
{
    STATE (hs, 4)        ^= STATE (hs, 0);
    if (a) STATE (hs, a) ^= STATE (hs, 0);
    if (b) STATE (hs, b) ^= STATE (hs, 0);
    if (c) STATE (hs, c) ^= STATE (hs, 0);
}

INLINE
void
Col_Xor_RORn (hashState* hs, int ror, int a, int b, int c)
{
    Col_Xor (hs, a, b, c);
    ROTATE (hs, ror);
}

#if 0
INLINE
void
Super_Mix (hashState* hs)
{
    hash32_s U[4],T1[4],T2[4],T3[4];
    uint32     r, c, k;

    /** AES substitution **/
    for (r=0; r<4; r++) for (c=0; c<4; c++)
        ENTRY (U, r, c) = aessub[BYTES(hs, r, c)];

    /**   M * U using multiplication table for entries in M  **/
    memset (T1, 0, sizeof (T1));
    for (r=0; r<4; r++) for (c=0; c<4; c++)  for (k=0; k<4; k++)
        ENTRY (T1, r, c) ^= gf2mul[ENTRY(U,k,c)].b[ENTRY(M,r,k)];

    /**   Create diagonal matrix Diag(U)   **/
    memset (T2, 0, sizeof (T2));
    for (r=0; r<4; r++) for (c=0; c<4; c++)
        if (r!=c) ENTRY (T2, r, r) ^= ENTRY (U, r, c);

    /**   Multiply T2 (Diag) by M transpose using multiplication table for entries in M   **/
    memset (T3, 0, sizeof (T3));
    for (r=0; r<4; r++) for (c=0; c<4; c++)  for (k=0; k<4; k++)
        ENTRY (T3, r, c) ^= gf2mul[ENTRY(T2,r,k)].b[ENTRY(M,c,k)];

    /** Add and Rotate Left **/
    for (r=0; r<4; r++) for (c=0; c<4; c++)
        BYTES (hs, r, (c-r)&3) = ENTRY (T1, r, c) ^ ENTRY (T3, r, c);
}
#else
INLINE
void
Super_Mix (hashState* hs)
{
    hash32_s U[4],D,W[4];
    uint32     r, c;

    /** AES substitution **/
    for (r=0; r<4; r++) for (c=0; c<4; c++)
        ENTRY (U, r, c) = aessub[BYTES(hs, r, c)];

    /**   Create diagonal matrix Diag(U)   **/
    memset (&D, 0, sizeof (D));
    for (r=0; r<4; r++) for (c=0; c<4; c++)
        if (r!=c) D.b[r] ^= ENTRY (U, r, c);

    /**   M * U + D * M transpose using multiplication table for entries in M  **/
    for (r=0; r<4; r++) for (c=0; c<4; c++)
        ENTRY (W, r, c) = gf2mul[ENTRY(U,0,c)].b[ENTRY(M,r,0)] 
                        ^ gf2mul[ENTRY(U,1,c)].b[ENTRY(M,r,1)] 
                        ^ gf2mul[ENTRY(U,2,c)].b[ENTRY(M,r,2)] 
                        ^ gf2mul[ENTRY(U,3,c)].b[ENTRY(M,r,3)] 
                        ^ gf2mul[D.b[r]].b[ENTRY(M,c,r)];      // only non-zero terms in diagonal matrix

    /** Rotate Left **/
    for (r=0; r<4; r++) for (c=0; c<4; c++)
        BYTES (hs, r, (c-r)&3) = ENTRY (W, r, c);
}
#endif

static
void
Fugue_IV ()
{
    hashState HS;
    int i;

    for (i=0; hashSizes[i].hashbitlen; i++)
    {
        uint32 Data = HO2BE_4 ((uint32)hashSizes[i].Cfg.n*32);
        memset (&HS, 0, sizeof (hashState));
        HS.hashbitlen = hashSizes[i].Cfg.n*32;
        HS.Cfg = &hashSizes[i].Cfg;
        Next_Fugue (&HS, &Data, 1);
        Done_Fugue (&HS, hashSizes[i].IV, NULL);
    }
}

#define POLY 0x11b
#define gf_0(x)   (0)
#define gf_1(x)   (x)
#define gf_2(x)   ((x<<1) ^ (((x>>7) & 1) * POLY))
#define gf_3(x)   (gf_2(x) ^ gf_1(x))
#define gf_4(x)   (gf_2(gf_2(x)))
#define gf_5(x)   (gf_4(x) ^ gf_1(x))
#define gf_6(x)   (gf_4(x) ^ gf_2(x))
#define gf_7(x)   (gf_4(x) ^ gf_2(x) ^ gf_1(x))

static
void
Make_Fugue ()
{
    uint32 i,j,k,sb,X[8],SB[256];

    if (init_fugue) return;
    init_fugue = 1;

/** multiplicative inverse with result repeated in 2 least significant bytes **/
    SB[0] = 0;
    SB[1] = (1<<8)|1;
    for (i=2;i<256;i++)
    {
        X[0] = i;
        for (j=1;j<8;j++)
            if ((X[j]=X[j-1]<<1)&256) X[j] ^= POLY;
        for (j=2;j<256;j++)
        {
            sb = 0;
            for (k=0;k<8;k++)
                if (j&(1<<k)) sb ^= X[k];
            if (sb==1) break;
        }
        SB[i] = (j<<8)|j;
    }
    for (i=0;i<256;i++)
    {
/** affine assuming repeated inverse from above **/
        aessub[i] = SB[i]^0x63;
        for (j=4;j<8;j++) aessub[i] ^= (SB[i]>>j);
/** GF2 multiplication table with n = 0 thru 7 **/
        gf2mul[i].b[0] = gf_0(i);
        gf2mul[i].b[1] = gf_1(i);
        gf2mul[i].b[2] = gf_2(i);
        gf2mul[i].b[3] = gf_3(i);
        gf2mul[i].b[4] = gf_4(i);
        gf2mul[i].b[5] = gf_5(i);
        gf2mul[i].b[6] = gf_6(i);
        gf2mul[i].b[7] = gf_7(i);
    }

/** generate M matrix **/
    ENTRY (M, 0, 0) = 1; ENTRY (M, 0, 1) = 4; ENTRY (M, 0, 2) = 7; ENTRY (M, 0, 3) = 1;
    ENTRY (M, 1, 0) = 1; ENTRY (M, 1, 1) = 1; ENTRY (M, 1, 2) = 4; ENTRY (M, 1, 3) = 7;
    ENTRY (M, 2, 0) = 7; ENTRY (M, 2, 1) = 1; ENTRY (M, 2, 2) = 1; ENTRY (M, 2, 3) = 4;
    ENTRY (M, 3, 0) = 4; ENTRY (M, 3, 1) = 7; ENTRY (M, 3, 2) = 1; ENTRY (M, 3, 3) = 1;

/** generate initial values **/
    Fugue_IV ();
}

uint32
Init_Fugue (hashState *hs, int hashbitlen)
{
    int i;

    Make_Fugue();
    if (!hs) return 0;
    memset (hs, 0, sizeof (hashState));
    for (i=0; hashSizes[i].hashbitlen; i++)
        if (hashSizes[i].hashbitlen==hashbitlen)
        {
            int n = hashSizes[i].Cfg.n;
            int s = hashSizes[i].Cfg.s;
            hs->hashbitlen = n*32;
            hs->Cfg = &hashSizes[i].Cfg;
            memcpy (&hs->State[s-n].d, hashSizes[i].IV, n*4);
            return 1;
        }
    return 0;
}

uint32
Load_Fugue (hashState* hs, int hashbitlen, const uint32* iv, int hashwordlen)
{
    int i;

    Make_Fugue ();
    if (!hs) return 0;
    memset (hs, 0, sizeof (hashState));
    for (i=0; hashSizes[i].hashbitlen; i++)
        if (hashSizes[i].hashbitlen==hashbitlen && hashSizes[i].Cfg.n==hashwordlen)
        {
            int n = hashSizes[i].Cfg.n;
            int s = hashSizes[i].Cfg.s;
            hs->hashbitlen = n*32;
            hs->Cfg = &hashSizes[i].Cfg;
            memcpy (&hs->State[s-n].d, iv, n*4);
            return 1;
        }
    return 0;
}

uint32
Next_Fugue (hashState* hs, const uint32* msg, uint64 len)
{
    uint32 k;

    if (!hs || !hs->Cfg) return 0;
    while (len--)
    {
        Input_Mix (hs, *msg++);
        for (k=0; k<hs->Cfg->k; k++)
        {
            ROR3_Col_Mix (hs);
            Super_Mix (hs);
        }
    }
    return 1;
}

uint32
Done_Fugue (hashState* hs, uint32* md, int* hashwordlen)
{
    if (hs && hs->Cfg)
    {
        int n = hs->Cfg->n;
        int s = hs->Cfg->s;
        int k = hs->Cfg->k;
        int r = hs->Cfg->r;
        int t = hs->Cfg->t;
        int N = cdiv (n, 4);
        int p = s / N, j;
        /* final G1 rounds */
        for (j=0; j<r*k; j++)
        {
            ROR3_Col_Mix (hs);
            Super_Mix (hs);
        }
        /* final G2 rounds */
        switch (N)
        {
        case 1: for (j=0; j<t; j++)
                {
                    Col_Xor_RORn (hs, s-1, 0, 0, 0);
                    Super_Mix (hs);
                }
                Col_Xor (hs, 0, 0, 0);
                break;
        case 2: for (j=0; j<t; j++)
                {
                    Col_Xor_RORn (hs, p,   p,   0, 0);
                    Super_Mix (hs);
                    Col_Xor_RORn (hs, p-1, p+1, 0, 0);
                    Super_Mix (hs);
                }
                Col_Xor (hs, p, 0, 0);
                break;
        case 3: for (j=0; j<t; j++)
                {
                    Col_Xor_RORn (hs, p,   p,   2*p,   0);
                    Super_Mix (hs);
                    Col_Xor_RORn (hs, p,   p+1, 2*p,   0);
                    Super_Mix (hs);
                    Col_Xor_RORn (hs, p-1, p+1, 2*p+1, 0);
                    Super_Mix (hs);
                }
                Col_Xor (hs, p, 2*p, 0);
                break;
        case 4: for (j=0; j<t; j++)
                {
                    Col_Xor_RORn (hs, p,   p,   2*p,   3*p);
                    Super_Mix (hs);
                    Col_Xor_RORn (hs, p,   p+1, 2*p,   3*p);
                    Super_Mix (hs);
                    Col_Xor_RORn (hs, p,   p+1, 2*p+1, 3*p);
                    Super_Mix (hs);
                    Col_Xor_RORn (hs, p-1, p+1, 2*p+1, 3*p+1);
                    Super_Mix (hs);
                }
                Col_Xor (hs, p, 2*p, 3*p);
                break;
        }
        /* digest output */
        for (j=0; j<4&&j<n; j++)
            *md++ = STATE (hs, j+1);
        for (r=1; r<=N-2; r++)
            for (j=0; j<4; j++)
                *md++ = STATE (hs, r*p+j);
        if (n>4)
            for (j=0; j+r*4<n; j++)
                *md++ = STATE (hs, s-p+j);
        if (hashwordlen) *hashwordlen = n;
        return 1;
    }
    return 0;
}
