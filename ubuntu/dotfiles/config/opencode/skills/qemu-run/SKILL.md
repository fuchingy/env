---
name: qemu-run
description: Use this skill when you need to run QEMU
---

# Run QEMU

**在2026/06/01證實可以用的流程**

這是David Chen提供，他說是QEMU team release的流程

## Prepare rootfs

1. Prepare rootfs

取得預先準備好的rootfs檔案
並建立一個mount資料夾，那個rootfs會掛進mount這資料夾

```bash
cp /nfs/teams/perf/dc-scratch/users/davidc2/2025-0225-qemu-pctrace-demo/demo-coreip-cli-sifive-fpga.rootfs-20250214202731.ext4 .
mkdir -p ./mount
```

2. 對這rootfs做e2fsck
如果不做這步驟的話，會出現 "Filesystem has unsupported read-only feature(s)." 錯誤訊息

```bash
/work/sparta/tools/e2fsprogs/sbin/e2fsck -fy ./demo-coreip-cli-sifive-fpga.rootfs-20250214202731.ext4
```

3. 將rootfs掛載到mount上

```bash
fuse2fs -o fakeroot ./demo-coreip-cli-sifive-fpga.rootfs-20250214202731.ext4 ./mount
```

4. 掛起來後，就可以往裡面增刪檔案了。下面命令示範新增一個123.txt檔案

```bash
touch ./mount/home/root/123.txt
```

5. 最後，記得要先unmount，才能執行QEMU

否則QEMU開機時會出現"Filesystem has unsupported read-only feature(s)." 錯誤訊息。不過如果這發生的話，可以用前述的e2fsck命令修復。

```bash
fusermount -u ./mount
```

## Execute QEMU

用以下命令跑起QEMU。

到登入提示命令時，用以下帳號密碼登入
帳號：root
密碼：sifive

可以留心一下，-kernel 是用一個預先存放好的kernel image，-drive 則指定到剛剛的那個rootfs檔案。

```bash
module load sifive/freedom-tools/qemu
qemu-system-riscv64 \
   -M virt  -m 4096 \
   -serial mon:stdio  -nographic \
   -kernel /nfs/teams/perf/share/simpoint-umbrella/deploy/2025-1013.c0fd8d1/p670/install/vmlinux.bin  \
   -device virtio-blk-device,drive=disk0 \
   -drive id=disk0,file=demo-coreip-cli-sifive-fpga.rootfs-20250214202731.ext4,if=none,format=raw \
   -append 'root=/dev/vda rw console=ttyS0 earlycon'
```

