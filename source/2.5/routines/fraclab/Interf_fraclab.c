#include "C-LAB_Interf.h"

/* scilab interface */

/* INTERFACE ROUTINE */
void C2F(fraclab_interf)()
{
    InterfInit();

    if (Interf.FuncIndex == 1)
        LAB_beep();

    if (Interf.FuncIndex == 2)
        LAB_bbch();

    if (Interf.FuncIndex == 3)
        LAB_linearlt();

    if (Interf.FuncIndex == 4)
        LAB_lepskiiap();

    if (Interf.FuncIndex == 5)
        LAB_monolr();

    if (Interf.FuncIndex == 6)
        LAB_cwt();

    if (Interf.FuncIndex == 7)
        LAB_alphagifs();

    if (Interf.FuncIndex == 8)
        LAB_sgifs();

    if (Interf.FuncIndex == 9)
        LAB_prescalpha();

    if (Interf.FuncIndex == 10)
        LAB_fif();

    if (Interf.FuncIndex == 11)
        LAB_binom();

    if (Interf.FuncIndex == 12)
        LAB_sbinom();

    if (Interf.FuncIndex == 13)
        LAB_multim1d();

    if (Interf.FuncIndex == 14)
        LAB_multim2d();

    if (Interf.FuncIndex == 15)
        LAB_smultim1d();

    if (Interf.FuncIndex == 16)
        LAB_smultim2d();

    if (Interf.FuncIndex == 17)
        LAB_readgif();

    if (Interf.FuncIndex == 18)
        LAB_FWT();

    if (Interf.FuncIndex == 19)
        LAB_IWT();

    if (Interf.FuncIndex == 20)
        LAB_WTDwnHi();

    if (Interf.FuncIndex == 21)
        LAB_WTDwnLo();

    if (Interf.FuncIndex == 22)
        LAB_fch1d();

    if (Interf.FuncIndex == 23)
        LAB_fcfg1d();

    if (Interf.FuncIndex == 24)
        LAB_mch1d();

    if (Interf.FuncIndex == 25)
        LAB_mcfg1d();

    if (Interf.FuncIndex == 26)
        LAB_cfg1d();

    if (Interf.FuncIndex == 27)
        LAB_FWT2D();

    if (Interf.FuncIndex == 28)
        LAB_IWT2D();

    if (Interf.FuncIndex == 29)
        LAB_mdzq1d();

    if (Interf.FuncIndex == 30)
        LAB_mdzq2d();

    if (Interf.FuncIndex == 31)
        LAB_reynitq();

    if (Interf.FuncIndex == 32)
        LAB_mdfl1d();

    if (Interf.FuncIndex == 33)
        LAB_sim_stable();

    if (Interf.FuncIndex == 34)
        LAB_McCulloch();

    if (Interf.FuncIndex == 35)
        LAB_Koutrouvelis();

    if (Interf.FuncIndex == 36)
        LAB_stable_sm();

    if (Interf.FuncIndex == 37)
        LAB_stable_test();

    if (Interf.FuncIndex == 38)
        LAB_stable_cov();

    if (Interf.FuncIndex == 39)
        LAB_holder2d();

    if (Interf.FuncIndex == 40)
        LAB_gifseg();

    if (Interf.FuncIndex == 41)
        LAB_wave2gifs();

    if (Interf.FuncIndex == 42)
        LAB_gifs2wave();

    InterfDone();
}
