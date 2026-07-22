# Tạo thư viện làm việc
vlib work

# Biên dịch tất cả các file mã nguồn Verilog và testbench
# (Bạn hãy liệt kê đủ các module con có trong dự án của bạn)
vlog alu.v branch_comp.v controller.v data_mem.v data_path.v ifu.v imm_gen.v instr_mem.v mux.v mux3.v reg_file.v processor.v processor_tb.v

# Bắt đầu mô phỏng với testbench (module top là processor_tb)
vsim work.processor_tb

# Thêm toàn bộ tín hiệu của testbench vào cửa sổ dạng sóng (Waveform)
add wave -position insertpoint sim:/processor_tb/*

# Mở rộng để xem tín hiệu bên trong CPU và DataPath (nếu cần)
add wave -position insertpoint sim:/processor_tb/a/*
add wave -position insertpoint sim:/processor_tb/a/dp/*

# Chạy mô phỏng (testbench đã có sẵn lệnh $finish nên dùng run -all)
run -all