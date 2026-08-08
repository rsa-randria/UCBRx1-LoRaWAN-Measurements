# UCBRx1 LoRaWAN Measurements

Experimental dataset, STM32WL55 firmware, and MATLAB processing scripts associated with the study:

**Decentralized Multi-Armed Bandit Learning for Energy-Efficient LoRaWAN Spectrum Access: Measurement-Based Evaluation**

This repository provides the experimental material used to characterize LoRaWAN Class-A communication energy and to evaluate Standard channel selection, UCB-based channel selection, and the ACK-timing-aware UCBRx1 reward-shaping mechanism.

## Overview

The study considers confirmed LoRaWAN uplinks in which the end-device selects one of the available uplink channels and observes the downlink ACK outcome.

For UCBRx1, the underlying UCB channel-selection rule is preserved, while the reward depends on the receive window in which the ACK is decoded:

- ACK decoded in RX1: full reward;
- ACK decoded in RX2: reduced reward;
- no ACK decoded: zero reward.

The repository focuses on the experimental and implementation aspects of the study, including hardware current measurements, transmission and receive-window profiling, ACK-timing measurements, per-channel experimental counters, STM32WL55 firmware, and MATLAB scripts used to process and visualize representative traces.

## Repository Structure

```text
UCBRx1-LoRaWAN-Measurements/
├── data/
│   ├── raw/
│   │   └── power_profiling/
│   │       ├── standard/
│   │       │   ├── Profile01/
│   │       │   ├── Profile02/
│   │       │   ├── Profile03/
│   │       │   ├── Profile04/
│   │       │   └── Profile05/
│   │       └── ucbrx1/
│   │           ├── Profile01/
│   │           ├── Profile02/
│   │           ├── Profile03/
│   │           ├── Profile04/
│   │           └── Profile05/
│   │
│   └── processed/
│       ├── power_profiling/
│       │   ├── receive_windows/
│       │   │   ├── rx1/
│       │   │   └── rx2/
│       │   └── transmission/
│       │       ├── standard/
│       │       └── ucb/
│       └── channel_performance/
│
├── firmware/
│   └── stm32wl55/
│       └── LoRaWAN_End_Node/
│
├── scripts/
│   ├── plot_Rx1_process.m
│   ├── plot_Rx2_process.m
│   └── plot_Tx_process.m
│
├── docs/
├── .gitattributes
├── .gitignore
└── README.md
```

## Experimental Platform

The experimental evaluation is based on a LoRaWAN Class-A end-device implemented on the STM32WL55 platform.

The power-profiling campaign characterizes the main communication phases, including MCU processing, radio calibration, uplink transmission, post-transmission processing, RX1 preparation and reception, RX2 preparation and reception, and post-reception processing.

Confirmed uplinks are considered according to three possible outcomes:

1. the ACK is decoded in RX1;
2. the ACK is decoded in RX2 after no ACK is decoded in RX1;
3. no ACK is decoded in either receive window.

This distinction is used to evaluate the service-energy cost associated with the LoRaWAN Class-A receive-window sequence.

## Raw Power-Profiling Measurements

Raw measurements are stored in:

```text
data/raw/power_profiling/
```

Two experimental configurations are provided:

```text
standard/
ucbrx1/
```

Each configuration contains five measurement profiles:

```text
Profile01/
Profile02/
Profile03/
Profile04/
Profile05/
```

For each profile, measurements are provided for payload lengths of 10, 20, 30, 40, and 50 bytes.

The main filename convention is:

```text
ppk-pm0_DR5_TXx_Lyy.ppk2
```

where:

- `DR5` identifies the data-rate configuration used during the profiling campaign;
- `TXx` identifies the transmit-power profile;
- `Lyy` identifies the application payload length in bytes.

For example:

```text
ppk-pm0_DR5_TX1_L10.ppk2
```

corresponds to transmission profile `TX1 = 16 dBm` with a 10-byte payload.

Most raw measurements are provided in the original Nordic Power Profiler Kit II (`.ppk2`) format.

One measurement is retained in CSV format:

```text
data/raw/power_profiling/standard/Profile03/ppk-pm0_DR5_TX3_L30.csv
```

Large raw measurement files are managed using Git LFS.

## Processed Power-Profiling Data

Processed and exported traces are stored separately from the raw measurements under:

```text
data/processed/power_profiling/
```

Two categories are provided:

```text
receive_windows/
transmission/
```

The `receive_windows/` directory contains representative RX1 and RX2 traces for Standard and UCB-based operation.

The `transmission/` directory contains representative transmission-side traces for Standard and UCB-based operation.

## Per-Channel Performance Dataset

Per-channel experimental counters are provided in:

```text
data/processed/channel_performance/
```

The dataset is available in both CSV and Excel formats:

```text
per_channel_performance_T1000_K8.csv
per_channel_performance_T1000_K8.xlsx
```

The dataset reports results for:

```text
T = 1000 confirmed uplinks
K = 8 uplink channels
```

for Standard, UCB, and UCBRx1.

The main reported counters are:

```text
Channel k
Channel Count (N_k)
No-ACK Count
RX1 ACK Count
RX2 ACK Count
```

These counters support the analysis of channel usage, delivery outcome, and ACK reception timing.

The per-channel dataset is derived from real-time network measurements collected through our LoRaWAN monitoring infrastructure. Additional real-time network characterization data are available through the following platforms:

- [LoRaWAN Network Server](https://lns.rrandria.com/)
- [Monitoring Dashboard](https://dashboard.rrandria.com/)
- [Wanesy Management Center](https://wmc.wanesy.com/)

Programmatic access to network and monitoring data is available through REST APIs.

Please contact the corresponding author for access credentials, API information, and additional data.

## STM32WL55 Firmware

The experimental end-device firmware is based on the `LoRaWAN_End_Node` application provided by STMicroelectronics and adapted for the evaluated channel-selection mechanisms.

The firmware is located under:

```text
firmware/stm32wl55/LoRaWAN_End_Node/
```

The STM32CubeIDE project files are located under:

```text
firmware/stm32wl55/LoRaWAN_End_Node/STM32CubeIDE/
```

Generated build outputs and local STM32CubeIDE workspace metadata are excluded from version control.

## MATLAB Scripts

Three MATLAB scripts are currently provided:

```text
scripts/plot_Tx_process.m
scripts/plot_Rx1_process.m
scripts/plot_Rx2_process.m
```

They use the processed CSV traces located under:

```text
data/processed/power_profiling/
```

and are intended to reproduce representative transmission and receive-window processing plots.

## Experimental Scope

The current experimental dataset corresponds to a controlled device-to-network LoRaWAN evaluation. It is intended to support reproducibility of the measurement-based energy characterization and the comparison of Standard, UCB, and UCBRx1 under the reported experimental conditions.

## Citation

Citation information for the associated publication and dataset will be added after publication and archival release.

A `CITATION.cff` file and a persistent dataset identifier may be provided with a future archived release.

## License

Third-party STM32, LoRaWAN, middleware, and driver components remain subject to their respective original licenses.
