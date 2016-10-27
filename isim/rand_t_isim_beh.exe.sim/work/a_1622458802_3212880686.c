/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

/* This file is designed for use with ISim build 0xa0883be4 */

#define XSI_HIDE_SYMBOL_SPEC true
#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
static const char *ng0 = "C:/Users/jelledevleeschouwer/Documents/Digitale Elektronica/Project/Project1/Rand.vhd";
extern char *IEEE_P_2592010699;
extern char *IEEE_P_3620187407;

unsigned char ieee_p_2592010699_sub_1744673427_503743352(char *, char *, unsigned int , unsigned int );
unsigned char ieee_p_2592010699_sub_2507238156_503743352(char *, unsigned char , unsigned char );
int ieee_p_3620187407_sub_514432868_3965413181(char *, char *, char *);


static void work_a_1622458802_3212880686_p_0(char *t0)
{
    char *t1;
    unsigned char t2;
    char *t3;
    char *t4;
    int t5;
    unsigned int t6;
    unsigned int t7;
    unsigned int t8;
    unsigned char t9;
    char *t10;
    char *t11;
    int t12;
    unsigned int t13;
    unsigned int t14;
    unsigned int t15;
    unsigned char t16;
    unsigned char t17;
    char *t18;
    char *t19;

LAB0:    xsi_set_current_line(49, ng0);
    t1 = (t0 + 992U);
    t2 = ieee_p_2592010699_sub_1744673427_503743352(IEEE_P_2592010699, t1, 0U, 0U);
    if (t2 != 0)
        goto LAB2;

LAB4:
LAB3:    t1 = (t0 + 3032);
    *((int *)t1) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(50, ng0);
    t3 = (t0 + 1488U);
    t4 = *((char **)t3);
    t5 = (7 - 7);
    t6 = (t5 * -1);
    t7 = (1U * t6);
    t8 = (0 + t7);
    t3 = (t4 + t8);
    t9 = *((unsigned char *)t3);
    t10 = (t0 + 1488U);
    t11 = *((char **)t10);
    t12 = (6 - 7);
    t13 = (t12 * -1);
    t14 = (1U * t13);
    t15 = (0 + t14);
    t10 = (t11 + t15);
    t16 = *((unsigned char *)t10);
    t17 = ieee_p_2592010699_sub_2507238156_503743352(IEEE_P_2592010699, t9, t16);
    t18 = (t0 + 1608U);
    t19 = *((char **)t18);
    t18 = (t19 + 0);
    *((unsigned char *)t18) = t17;
    xsi_set_current_line(51, ng0);
    t1 = (t0 + 1488U);
    t3 = *((char **)t1);
    t6 = (7 - 6);
    t7 = (t6 * 1U);
    t8 = (0 + t7);
    t1 = (t3 + t8);
    t4 = xsi_get_transient_memory(7U);
    memcpy(t4, t1, 7U);
    t10 = (t0 + 1488U);
    t11 = *((char **)t10);
    t13 = (7 - 7);
    t14 = (t13 * 1U);
    t15 = (0 + t14);
    t10 = (t11 + t15);
    memcpy(t10, t4, 7U);
    xsi_set_current_line(52, ng0);
    t1 = (t0 + 1608U);
    t3 = *((char **)t1);
    t2 = *((unsigned char *)t3);
    t1 = (t0 + 1488U);
    t4 = *((char **)t1);
    t5 = (0 - 7);
    t6 = (t5 * -1);
    t7 = (1U * t6);
    t8 = (0 + t7);
    t1 = (t4 + t8);
    *((unsigned char *)t1) = t2;
    xsi_set_current_line(54, ng0);
    t1 = (t0 + 1488U);
    t3 = *((char **)t1);
    t1 = (t0 + 5356U);
    t5 = ieee_p_3620187407_sub_514432868_3965413181(IEEE_P_3620187407, t3, t1);
    t12 = (192 + t5);
    t4 = (t0 + 1728U);
    t10 = *((char **)t4);
    t4 = (t10 + 0);
    *((int *)t4) = t12;
    xsi_set_current_line(56, ng0);
    t1 = (t0 + 1728U);
    t3 = *((char **)t1);
    t5 = *((int *)t3);
    t1 = (t0 + 3112);
    t4 = (t1 + 56U);
    t10 = *((char **)t4);
    t11 = (t10 + 56U);
    t18 = *((char **)t11);
    *((int *)t18) = t5;
    xsi_driver_first_trans_fast_port(t1);
    goto LAB3;

}


extern void work_a_1622458802_3212880686_init()
{
	static char *pe[] = {(void *)work_a_1622458802_3212880686_p_0};
	xsi_register_didat("work_a_1622458802_3212880686", "isim/rand_t_isim_beh.exe.sim/work/a_1622458802_3212880686.didat");
	xsi_register_executes(pe);
}
