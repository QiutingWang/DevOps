# MLOps Tools1: MLFlow Introduction

## References

- MLflow Tracking. <https://mlflow.org/docs/latest/tracking.html#concepts>
- Case: Deploying Large Language Models in Production: LLMOps with MLflow. <https://www.analyticsvidhya.com/blog/2023/05/deploying-large-language-models-in-production-llmops-with-mlflow/>
- Experiment Tracking. Made with ML. <https://madewithml.com/courses/mlops/experiment-tracking/>
- MLOps极致细节：4. MLFlow Projects 案例介绍（Gitee代码链接）<https://blog.csdn.net/zyctimes/article/details/123311876>

## Overview of MLFlow

- Tracking
  - log parameters: 
    - Syntax: `mlflow.log_param("key", value)`
    - both key and value are string.
    - we pass these when training models
  - log metric:
    - Syntax: `mlflow.log_metric("key", value)`
    - update throughout model running
  - log artifacts:
    - Syntax: `mlflow.log_artifact(.png/.pkl)`
    - path of output files which can be images, models, data

- Project
  - defined with YAML configuration, a MLProject file. Specify:
    - entry point: 
      - pass (default) value to <u>parameters</u> with data type
      - define a <u>command</u> to run
    - project environment: python, docker, conda, virtualenv
    - project directories
    - build dependencies

- Models
  - flavor: package ML models in multiple formats
  - model is saved with a directory containing arbitrary files + descriptor file(list the specific flavor)
  - serve the model:`mlflow.flavorName.log_model()`
    - flavor can be: sklearn, tensorflow, h2o, spark, python_function, openai, pytorch, statsmodels, ...or customized flavor with `mlflow.models.Model`

## Installation

- In terminal: 
  - python and Apple Command Line Tools Xcode environment are needed: 
  - `brew install python`
  - `xcode-select --install`
  - `pip3 install mlflow`
- Running on the server: `mlflow ui`
- running locally, open the Google Chrome `http://127.0.0.1:5000`
超耗时间😕

## Introduction to Tracking UI

- to create another new experiment, we type `mlflow experiments create --experiment-name XXXX` in terminal, return with defined experiment name and unique id. 
  - On UI, there is nothing under newly defined experiment
  - To run the experiment, type in `MLFLOW_EXPERIMENT_ID=569435006108818269 python XXXX.py`
- mlruns
  - `ls` under mlruns
  - `tree mlruns`: show parameters, metrics, tags, artifacts, meta.yaml under ids

## Parameters, Version, Artifacts, Metrics

- Run the databricks example project in terminal: `mlflow run git@github.com:databricks/mlflow-example.git -P alpha=5`
- details can be found at Artifacts on UI.