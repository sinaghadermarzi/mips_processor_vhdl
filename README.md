# mips_processor_vhdl

VHDL sources for a single-cycle, 32-bit MIPS-style processor core written as a course project, together with
the building blocks (ALU, adder, memories, counters) and a few testbenches that were developed alongside it.
The files are a working snapshot rather than a cleaned-up design: several files exist in more than one
revision, and some of the testbenches are incomplete.

## What is in the repo

All files sit at the top level; there is no build system or simulator script.

**Processor core**

| File | Contents |
|---|---|
| `MIPS_processor (2).vhd` | The most complete version of the `core` entity (~600 lines). Fetch/decode/execute/write-back as concurrent processes with a 32-entry register file. Decodes R-type register arithmetic (incl. `jr`), I-type immediate arithmetic (`addi`, `addiu`, `andi`, `ori`, `slti`, `sltiu`, `xori`), `lw`, `sw`, `beq`, `bne`, `j` and `jal`. The ALU is inlined in the same file. Instruction and data memories are external: the core exposes `IMdin`/`IM_addr_out` and `DM_din`/`DM_dout`/`DM_addr_out`/`DM_write` ports. |
| `MIPS_processor.vhd`, `MIPS_processor (3).vhd` | Earlier, shorter drafts of the same `core` entity. |
| `mips_core(mhf).vhd` | An alternative early draft (`mips_core` entity with an empty port list) with a `regdst`/`alusrc`/`memtoreg`-style control signal layout. |
| `MIPS_tb.vhd` | Started testbench for `core` with `imemory`/`dmemory` stubs. It is unfinished and does not compile as is (missing library clauses, incomplete architectures, trailing `;` in port lists). |

**Building blocks**

| File | Contents |
|---|---|
| `ALU.VHD` | Behavioural 32-bit ALU (`alu` entity, 6-bit `alu_op`): addu, and, or, sll/sllv, srl/srlv, subu, slt, set-on-equal/not-equal. |
| `ALU (2).vhd` | A different, generic-width bit-slice ALU (`alu_bitcell` + `alu` with generic `n`, 4-bit `func`, overflow output). |
| `ALU_TEST.VHD` | Testbench for the bit-slice ALU in `ALU (2).vhd`. |
| `ADDER.VHD` | 1-bit full `adder` (rtl and structural architectures) and a generic N-bit `adderN` (structural ripple-carry and behavioural architectures). |
| `testadder.vhd` | Testbench for an 8-bit `adderN`. |
| `32BITMEM.VHD`, `INS_MEM.VHD` | 32 x 32-bit memories (`mem32`, `insmem`) with a read/write select (`nrw`). |
| `EXTEND.VHD` | Fragment of the immediate/shamt extend logic (process only, no entity). |
| `COUNTER.VHD` | 8-bit counter using `bit_vector` with propagation delays. |
| `ucount_process.vhd`, `ucount_tb.vhd` | Generic up/down counter (`ucount`, mode input) and its testbench. |

## Simulating

The sources were written for a standard VHDL simulator (they use `ieee.std_logic_1164` and
`ieee.std_logic_unsigned`); no project or script files are included. To try a component, create a project in
your simulator (e.g. ModelSim/Questa, or GHDL on the command line), add the unit and its testbench, and run the
testbench entity:

- `ADDER.VHD` + `testadder.vhd` -> run `testbench` (architecture `adder8`)
- `ALU (2).vhd` + `ALU_TEST.VHD` -> run `tb_alu`
- `ucount_process.vhd` + `ucount_tb.vhd` -> run `ucount_tb`

Do not add `ALU.VHD` and `ALU (2).vhd` to the same library: both declare an entity named `alu`. Likewise the
three `MIPS_processor*.vhd` files all declare `core`; pick one (normally `MIPS_processor (2).vhd`).

## Caveats

- `MIPS_tb.vhd` and `EXTEND.VHD` are unfinished fragments and will not analyse without edits.
- There is no assembled program or memory image for the core; the instruction memory in the testbench is a
  two-entry placeholder.
- The duplicate file names (`(2)`, `(3)`, `(mhf)`) are the original working copies and have been kept as they
  were committed.
