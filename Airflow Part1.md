# Airflow Part1 Introduction

## References

- Install docker compose offical documentation: <https://airflow.apache.org/docs/apache-airflow/stable/howto/docker-compose/index.html>
- Apache airflow for beginners. <https://www.youtube.com/watch?v=TkvX1L__g3s&list=PLzKRcZrsJN_xcKKyKn18K7sWu5TTtdywh&index=3>
- Airflow API(Stable) <http://localhost:8080/api/v1/ui/>

## The Role of Airflow 

- Not a data processing tool, but <u>orchestrates</u> various components which process data in *data pipelines* with several tasks.
- Batch oriented framework using python to define workflows
- DAG(directed acyclic graph)
  - graph-based representation
  - the direction with <u>arrows</u> shows the *dependency* of tasks with specific orders
  - task: node
  - without containing any loop or cycle
  - *mark* the completed tasks once they finish performing their work and its upstream tasks in execution queue
- The advantages over sequential scripts
  - can include <u>parallel</u> workflow, using available resources and decreasing 
  - separate pipelines into small incremental tasks rather than *single monolithic script* that introduces inefficiency when tasks fail.
  - Incremental load and build pipelines without expensive recomputation(version control easily)
    - Backfilling: execute *new DAG* for historical schedule intervals to <u>create new data set</u> with historical data
    - rerun the historical tasks by cleaning results of past runs
- DAG files:
  - written in python scripts
    - Advantages:
      - flexibility
      - easy to customize for building complex pipelines
      - accessible to many Airflow extensions and wide variety of systems
  - Structure: tasks + dependency + metadata + schedule interval(when pipelines is run by Airflow)
- Three Main Components of Airflow
  - Airflow scheduler: the heart of Airflow
    - parse DAGs, check the schedule interval of DAG's and dependencies
    - pass tasks into <u>execution queue</u>
    - for scheduled tasks, check whether the *upstream tasks* have been completed.
  - Airflow worker
  - Airflow webserver: 
    - visualize, monitor DAGs run, manage failures and results using UI 
    - provide tree view for conveniently debugging
  
## Airflow Setup on Docker

- Make sure we already have docker environment, check: `docker --version` and `docker-compose --version` in terminal
- Install on docker: 
  - Docker compose: `curl -LfO 'https://airflow.apache.org/docs/apache-airflow/2.6.1/docker-compose.yaml'`
  - Initialization: `docker-compose up airflow-init`
  - Run: `docker compose up`
  - Open in Google Chrome: `localhost:8080`, enter the username and password
    - By default, The account name created has the login `airflow` and the password `airflow`.

## Write My First Pipeline DAG

- Building blocks:
  - Configurations: schedule time, retries, failure handler, SLA, timeouts
  - Operator: Bash, Python, KubernetesPod...
  - Task: operator instance
  - Dependency: workflow

- Demo address: <https://colab.research.google.com/drive/155gmM0H2C2aGhplhmn1DaU55dHF0XGId?usp=sharing>