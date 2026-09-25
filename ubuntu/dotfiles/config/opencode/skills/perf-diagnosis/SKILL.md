---
name: perf-diagnosis
description: Use this skill when developing the PerfDiagnosis. PerfDiagnosis is a step in the federation for automatically diagosing performance issues. The development is in federations' tools/perf-tools/src/perf_tools folders. For any file under this folder, use this skill.
---

# About PerfDiagnosis

PerfDiagnosis是一個federation的test-planner step，用來在RTLsim結束後，診斷效能out-of-bound的case的問題在哪裡。

更詳細的說，在每次跑一個 plan.yaml 檔案的時候，總是會跑很多個 configuration，而每個 configuration 之下又有很多個 test。
每個 test 都會有一個效能檢定的標準 (存在specs/perf之下)，如果超出該標準，就會被視為有效能問題 (out-of-bound)。
PerfDiagnosis 的目標，就是要找出超出標準的原因可能是什麼。

## Methodology

他的做法是這樣：
每個 configuration 的每一個 test 都會有一份對應的 golden資料，該資料是來自於先前執行時的正常結果。
PerfDiagnosis 的功能就是去比對待測目標和 golden 之間的差異，並從中找出問題。
因為每個測項所涵蓋的面向可能不同，所以他在調查問題時，也可能參考其他測項的結果，進而做一個聯合的診斷。

## Actual steps

整個運作的具體步驟包含以下：

1. 收集此次量測的所有結果
   (a) 確認這一次有哪些測項
   (b) 瞭解效能檢定的標準是什麼，以及有沒有超出標準
2. 處理待測項目的檔案
   (a) 找到對應的 golden 檔案，並調用工具進行分析待測目標的檔案和 golden 的檔案的差異
      - 這些工具包含但不限于：lob_processor.py, perfsight_processor.py, json_processor.py 等等
   (b) 將檔案之間的差異儲存為檔案: diagnosis_data.json
   (c) 產生 HTML 報告，以便人員分析這些差異
3. 進行自動化診斷
   (a) 讀取diagnosis_data.json，以得到差異資料
   (b) 將差異資料傳給診斷函式，以分析並回報問題

## AI assist diagnoser script development

關於自動化診斷函式的開發，會用 AI 來輔助，其具體步驟如下：

1. 在 2(b) 我們有與 golden 之間的差異資料檔案 diagnosis_data.json
2. 我們將這個檔案交給 AI 分析，並教導 AI 如何分析這個檔案
3. AI 藉著分析所學得的知識，來撰寫對應到各個測項的診斷函式。具體說，就是各個diagnosis_*.py檔案中的diagnose() 函式。目前diagnosis_*.py檔案有以下這些：
  - diagnosis_coremark.py
  - diagnosis_dhrystone.py
  - diagnosis_quick_lat_mem_rd.py
  - diagnosis_vector_bw.py

### 訓練AI來寫script的提示詞

底下是教導AI寫 diagnosis_vector_bw.py 的diagnose() 函式的提示詞範例。分為1)學習階段和2)撰寫階段

1) 學習階段

```text
請按以下步驟來執行：

1. 用 report_interpretor.md 來理解 diagnosis_data.json
2. 找到 diagnosis_data.json中vector_bw中out-of-bound的測項
3. 用 vector_bw_diagnosis.md 來分析該out-of-bound的測項跟怎樣的design spec改變有關係
```

2)撰寫階段

```text
現在按照你學習到的，把分析方法寫成程式，填入 diagnosis_vector_bw.py 的 diagnose() 函式中
你要先理解 diagnosis_vector_bw.py，以及它如何在 perf_diagnosis.py 中被呼叫，還有它的 diagnose function prototype 接收怎樣的參數。

這樣子你才知道填入 diagnose 函式的實作時，該怎麼填才是對的。
```