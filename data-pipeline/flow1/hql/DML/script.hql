
set hive.execution.engine=tez;
--set hive.exec.dynamic.partition.mode=nonstrict;
--set hive.exec.dynamic.partition=true;
--set hive.enforce.bucketing=true;
--set hive.enforce.sorting=true;
--set hive.exec.dynamic.partition.mode=nonstrict;
--set hive.exec.max.dynamic.partitions.pernode=100000;
--set hive.exec.max.dynamic.partitions=100000;
--set hive.exec.max.created.files=1000000;
--set hive.exec.parallel=true;
--set hive.exec.reducers.max=2000;
--set hive.stats.autogather=true;
--set hive.optimize.sort.dynamic.partition=true;

--set mapred.job.reduce.input.buffer.percent=0.0;
--set mapreduce.input.fileinputformat.split.minsizee=240000000;
--set mapreduce.input.fileinputformat.split.minsize.per.node=240000000;
--set mapreduce.input.fileinputformat.split.minsize.per.rack=240000000;

--set hive.tez.container.size=1024;

--set hive.vectorized.execution.enabled = true;
--set hive.vectorized.execution.reduce.enabled=true;

--set hive.cbo.enable=true;
--set hive.compute.query.using.stats = true;


--* Step1 : Load Data INTO THE RAW TABLE *--
LOAD DATA INPATH '/user/hue/SV-sample.xml' INTO TABLE `test1.raw_xml`

--********** QUERY NUMBER 1 ************---

insert into table raw_json
select convertJArr2Obj(convertX2J(row)) from raw_xml;

--********** QUERY NUMBER 2 ************---

LOAD DATA INPATH '/user/ambari-qa/data_pipeline_demo/hivedb/raw_json/' INTO TABLE `test2.sv_json_data`;

--********** QUERY NUMBER 3 ************---

insert into table sv_aggregate
select studyid,visit,year(svstdtc),month(svstdtc),count(*) from sv_json_data
group by 
studyid,visit,year(svstdtc),month(svstdtc)
;