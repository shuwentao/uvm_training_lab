#VLOGAN_OPTS += -work xil_defaultlib
VLOGAN_OPTS += -sverilog
VLOGAN_OPTS += -debug_all
VLOGAN_OPTS += -full64
VLOGAN_OPTS += +verilog2001ext+.vp
VLOGAN_OPTS += -timescale=1ns/1ns
VLOGAN_OPTS += -l comp.log
VLOGAN_OPTS += -f flist.f

VCS_OPTS += -full64
VCS_OPTS += -debug_pp 
VCS_OPTS += -timescale=1ns/1ns 
VCS_OPTS += -licqueue 
VCS_OPTS += ../uvm-1.1a/src/dpi/uvm_dpi.cc -CFLAGS -DVCS
VCS_OPTS += -LDFLAGS -Wl,--no-as-needed
#VCS_OPTS += glbl 
VCS_OPTS += -top tb    
VCS_OPTS += -l elaborate.log 

#.DEFAULT_GOAL=clean
.DEFAULT_GOAL=all 
all:
	make clean
	make compile
	make elaborate
	make simulate

compile:
	vlogan $(VLOGAN_OPTS)	

elaborate:
	vcs $(VCS_OPTS) 
		

simulate:
	./simv +UVM_TESTNAME=my_test_inst_da3 -l simulate.log 

clean:
	rm -rf *.daidir
	rm -rf DVEfiles
	rm -rf simv 
	rm -rf *.vpd 
	rm -rf AN.DB 
	rm -rf vc_hdrs.h 
	rm -rf csrc
	rm -rf vcs_lib
	rm -rf *.log
	rm -f novas.conf
	rm -f ucli.key
	rm -rf golden
	rm -rf rslt
	rm -rf ../env/target_sim_define.v
	rm -rf ../env/target_test_case.sv

