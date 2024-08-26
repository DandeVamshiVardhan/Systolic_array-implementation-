/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   115200
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xil_io.h"
#include "xparameters.h"

void delay(int dl){
	for(int i=0;i<dl;){
		i = i + 1;
	}
}

int main()
{
    init_platform();
    int r1,r2,r3,r4;

    /* code is written for 2*2 matrix multiplication of two matrices and output is displayed by reading from
     *    register
     *    |1.5 2.5| * |1.5 2.5| = |9.75 12.5 |
     *    |3   3.5|   |3   3.5|   |15   19.75|
     *    input is given in IEE 754 floating point representation and output is also read in same representation
     */


   // Xil_Out32 is used to write to that particular register


           Xil_Out32(XPAR_MATRIX_COLVOLUTION_V_0_BASEADDR  + 4*8, 51);    // slv_reg8=weight dimension 33hex
           Xil_Out32(XPAR_MATRIX_COLVOLUTION_V_0_BASEADDR + 4*9, 34);     // slv_reg9=input_dimension  22hex
           Xil_Out32(XPAR_MATRIX_COLVOLUTION_V_0_BASEADDR + 4*1, 0);     // slv_reg1 is load_in
           Xil_Out32(XPAR_MATRIX_COLVOLUTION_V_0_BASEADDR  + 4*2, 0);     // slv_reg2 is weight_in
           Xil_Out32(XPAR_MATRIX_COLVOLUTION_V_0_BASEADDR  + 4*3, 0);     // slv_reg3 is start




    	   Xil_Out32(XPAR_MATRIX_COLVOLUTION_V_0_BASEADDR  + 4*0, 1065353216);  // slv_reg0 is data
    	   delay(5);
    	   Xil_Out32(XPAR_MATRIX_COLVOLUTION_V_0_BASEADDR  + 4*1, 1);   // slv_reg1 is load_in
    	   Xil_Out32(XPAR_MATRIX_COLVOLUTION_V_0_BASEADDR  + 4*2, 1);  // slv_reg2 is weight_in
    	   delay(5);
    	   Xil_Out32(XPAR_MATRIX_COLVOLUTION_V_0_BASEADDR  + 4*1, 0);  // slv_reg1 is load_in
    	   Xil_Out32(XPAR_MATRIX_COLVOLUTION_V_0_BASEADDR + 4*2, 0);  // slv_reg2 is weight_in

    	   Xil_Out32(XPAR_MATRIX_COLVOLUTION_V_0_BASEADDR  + 4*0, 1073741824);  // slv_reg0 is data
    	    delay(5);
    	   Xil_Out32(XPAR_MATRIX_COLVOLUTION_V_0_BASEADDR  + 4*1, 1);   // slv_reg1 is load_in
    	   Xil_Out32(XPAR_MATRIX_COLVOLUTION_V_0_BASEADDR  + 4*2, 1);  // slv_reg2 is weight_in
    	   delay(5);
    	   Xil_Out32(XPAR_MATRIX_COLVOLUTION_V_0_BASEADDR  + 4*1, 0);  // slv_reg1 is load_in
    	   Xil_Out32(XPAR_MATRIX_COLVOLUTION_V_0_BASEADDR + 4*2, 0);  // slv_reg2 is weight_in

    	   Xil_Out32(XPAR_MATRIX_COLVOLUTION_V_0_BASEADDR  + 4*0, 1077936128);  // slv_reg0 is data
    	    delay(5);
    	   Xil_Out32(XPAR_MATRIX_COLVOLUTION_V_0_BASEADDR  + 4*1, 1);   // slv_reg1 is load_in
    	   Xil_Out32(XPAR_MATRIX_COLVOLUTION_V_0_BASEADDR  + 4*2, 1);  // slv_reg2 is weight_in
    	   delay(5);
    	   Xil_Out32(XPAR_MATRIX_COLVOLUTION_V_0_BASEADDR  + 4*1, 0);  // slv_reg1 is load_in
    	   Xil_Out32(XPAR_MATRIX_COLVOLUTION_V_0_BASEADDR  + 4*2, 0);  // slv_reg2 is weight_in

    	   Xil_Out32(XPAR_MATRIX_COLVOLUTION_V_0_BASEADDR  + 4*0, 1082130432);  // slv_reg0 is data
    	    delay(5);
    	   Xil_Out32(XPAR_MATRIX_COLVOLUTION_V_0_BASEADDR  + 4*1, 1);   // slv_reg1 is load_in
    	   Xil_Out32(XPAR_MATRIX_COLVOLUTION_V_0_BASEADDR  + 4*2, 1);  // slv_reg2 is weight_in
    	   delay(5);
    	   Xil_Out32(XPAR_MATRIX_COLVOLUTION_V_0_BASEADDR  + 4*1, 0);  // slv_reg1 is load_in
    	   Xil_Out32(XPAR_MATRIX_COLVOLUTION_V_0_BASEADDR  + 4*2, 0);  // slv_reg2 is weight_in



    	   Xil_Out32(XPAR_MATRIX_COLVOLUTION_V_0_BASEADDR  + 4*0, 1065353216);  // slv_reg0 is data
    	    delay(5);

    	   Xil_Out32(XPAR_MATRIX_COLVOLUTION_V_0_BASEADDR  + 4*2, 1);  // slv_reg2 is weight_in
    	   delay(5);

    	   Xil_Out32(XPAR_MATRIX_COLVOLUTION_V_0_BASEADDR  + 4*2, 0);  // slv_reg2 is weight_in



    	   Xil_Out32(XPAR_MATRIX_COLVOLUTION_V_0_BASEADDR  + 4*0, 1073741824);  // slv_reg0 is data
    	    delay(5);

    	   Xil_Out32(XPAR_MATRIX_COLVOLUTION_V_0_BASEADDR  + 4*2, 1);  // slv_reg2 is weight_in
    	   delay(5);

    	   Xil_Out32(XPAR_MATRIX_COLVOLUTION_V_0_BASEADDR  + 4*2, 0);  // slv_reg2 is weight_in



    	   Xil_Out32(XPAR_MATRIX_COLVOLUTION_V_0_BASEADDR  + 4*0, 1077936128);  // slv_reg0 is data
    	    delay(5);

    	   Xil_Out32(XPAR_MATRIX_COLVOLUTION_V_0_BASEADDR  + 4*2, 1);  // slv_reg2 is weight_in
    	   delay(5);

    	   Xil_Out32(XPAR_MATRIX_COLVOLUTION_V_0_BASEADDR  + 4*2, 0);  // slv_reg2 is weight_in




    	   Xil_Out32(XPAR_MATRIX_COLVOLUTION_V_0_BASEADDR  + 4*0, 1082130432);  // slv_reg0 is data
    	    delay(5);

    	   Xil_Out32(XPAR_MATRIX_COLVOLUTION_V_0_BASEADDR  + 4*2, 1);  // slv_reg2 is weight_in
    	   delay(5);

    	   Xil_Out32(XPAR_MATRIX_COLVOLUTION_V_0_BASEADDR  + 4*2, 0);  // slv_reg2 is weight_in



    	   Xil_Out32(XPAR_MATRIX_COLVOLUTION_V_0_BASEADDR  + 4*0, 1082130432);  // slv_reg0 is data
    	    delay(5);

    	   Xil_Out32(XPAR_MATRIX_COLVOLUTION_V_0_BASEADDR  + 4*2, 1);  // slv_reg2 is weight_in
    	   delay(5);

    	   Xil_Out32(XPAR_MATRIX_COLVOLUTION_V_0_BASEADDR  + 4*2, 0);  // slv_reg2 is weight_in






       delay(5);
       Xil_Out32(XPAR_MATRIX_COLVOLUTION_V_0_BASEADDR  + 4*3, 1);     // slv_reg3 is start


       delay(10000);


       // Xil_In32 is used to read that particular register

       r1 = Xil_In32(XPAR_MATRIX_COLVOLUTION_V_0_BASEADDR  + 4*4);  // slv_reg4 is mem_data1
       r2 = Xil_In32(XPAR_MATRIX_COLVOLUTION_V_0_BASEADDR  + 4*5);  // slv_reg5 is mem_data1
       r3 = Xil_In32(XPAR_MATRIX_COLVOLUTION_V_0_BASEADDR  + 4*6);  // slv_reg6 is mem_data1
       r4 =	Xil_In32(XPAR_MATRIX_COLVOLUTION_V_0_BASEADDR + 4*7);  // slv_reg7 is mem_data1

       xil_printf(" %d \n  %d \n",r1,r2);
       xil_printf(" %d \n %d\n ",r3,r4);

    cleanup_platform();
    return 0;
}
