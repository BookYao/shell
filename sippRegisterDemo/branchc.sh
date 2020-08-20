#!/bin/bash
# -i: local ip
# -m: 多少次并发
# -trace_msg: 产生调试日志
# -trace_err: 产生错误日志
# 10.0.0.47:7080: 服务器地址
# -aa: 自动回复 200Ok

sipp -sf branchc.xml -inf user.csv -i 192.168.50.132 -m 1000 -trace_msg 10.0.0.47:7080 -aa -trace_err
