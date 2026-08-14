```
$ sudo docker run -it --entrypoint /usr/local/bin/llama-bench --device=/dev/kfd --device=/dev/dri --group-add video --volume /media/hdd10TB/Models:/models ghcr.io/jonathanmajh/llama-cpp:3 -m /models/models--llmfan46--gemma-4-12B-it-qat-q4_0-uncensored-heretic-GGUF/snapshots/7a42f59cccc95bae4de8874806a3d41a5633aff0/gemma-4-12B-it-qat-q4_0-uncensored-heretic-Q4_0.gguf -fa 1 -r 2 -n 0 -p 1024 -ub 512,1024,2048,4096 -b 512,1024,2048,4096
```


```
ggml_cuda_init: found 2 ROCm devices (Total VRAM: 32736 MiB):
  Device 0: AMD Radeon Instinct MI25, gfx900:xnack- (0x900), VMM: no, Wave Size: 64, VRAM: 16368 MiB
  Device 1: AMD Radeon Instinct MI25, gfx900:xnack- (0x900), VMM: no, Wave Size: 64, VRAM: 16368 MiB
  ```


| model                          |       size |     params | backend    | ngl | n_batch | n_ubatch |  fa |            test |                  t/s |
| ------------------------------ | ---------: | ---------: | ---------- | --: | ------: | -------: | --: | --------------: | -------------------: |
| gemma4 ?B Q4_0                 |   7.06 GiB |    11.91 B | ROCm       |  -1 |     512 |      512 |   1 |          pp1024 |        210.90 ± 0.85 |
| gemma4 ?B Q4_0                 |   7.06 GiB |    11.91 B | ROCm       |  -1 |     512 |     1024 |   1 |          pp1024 |        209.24 ± 0.46 |
| gemma4 ?B Q4_0                 |   7.06 GiB |    11.91 B | ROCm       |  -1 |     512 |     2048 |   1 |          pp1024 |        210.43 ± 0.39 |
| gemma4 ?B Q4_0                 |   7.06 GiB |    11.91 B | ROCm       |  -1 |     512 |     4096 |   1 |          pp1024 |        209.95 ± 0.25 |
| gemma4 ?B Q4_0                 |   7.06 GiB |    11.91 B | ROCm       |  -1 |    1024 |      512 |   1 |          pp1024 |        209.06 ± 0.59 |
| gemma4 ?B Q4_0                 |   7.06 GiB |    11.91 B | ROCm       |  -1 |    1024 |     1024 |   1 |          pp1024 |        185.69 ± 3.23 |
| gemma4 ?B Q4_0                 |   7.06 GiB |    11.91 B | ROCm       |  -1 |    1024 |     2048 |   1 |          pp1024 |        191.97 ± 1.64 |
| gemma4 ?B Q4_0                 |   7.06 GiB |    11.91 B | ROCm       |  -1 |    1024 |     4096 |   1 |          pp1024 |        191.13 ± 0.30 |
| gemma4 ?B Q4_0                 |   7.06 GiB |    11.91 B | ROCm       |  -1 |    2048 |      512 |   1 |          pp1024 |        207.98 ± 0.01 |
| gemma4 ?B Q4_0                 |   7.06 GiB |    11.91 B | ROCm       |  -1 |    2048 |     1024 |   1 |          pp1024 |        190.92 ± 0.48 |
| gemma4 ?B Q4_0                 |   7.06 GiB |    11.91 B | ROCm       |  -1 |    2048 |     2048 |   1 |          pp1024 |        191.37 ± 1.75 |
| gemma4 ?B Q4_0                 |   7.06 GiB |    11.91 B | ROCm       |  -1 |    2048 |     4096 |   1 |          pp1024 |        190.86 ± 1.38 |
| gemma4 ?B Q4_0                 |   7.06 GiB |    11.91 B | ROCm       |  -1 |    4096 |      512 |   1 |          pp1024 |        207.39 ± 0.55 |
| gemma4 ?B Q4_0                 |   7.06 GiB |    11.91 B | ROCm       |  -1 |    4096 |     1024 |   1 |          pp1024 |        190.38 ± 1.09 |
| gemma4 ?B Q4_0                 |   7.06 GiB |    11.91 B | ROCm       |  -1 |    4096 |     2048 |   1 |          pp1024 |        190.56 ± 1.66 |
| gemma4 ?B Q4_0                 |   7.06 GiB |    11.91 B | ROCm       |  -1 |    4096 |     4096 |   1 |          pp1024 |        190.48 ± 0.84 |