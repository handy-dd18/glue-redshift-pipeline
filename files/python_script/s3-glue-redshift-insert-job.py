import sys
import pyspark.pandas as ps
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from awsglue import DynamicFrame

args = getResolvedOptions(sys.argv, ['JOB_NAME'])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

# ジョブパラメーターを受け取る
args = getResolvedOptions(sys.argv, ['bucket', 'bucket_key'])

bucket = args['bucket']
bucket_key = args['bucket_key']

# Script generated for node Amazon S3
AmazonS3_node = glueContext.create_dynamic_frame.from_options(
    format_options={"quoteChar": "\"", "withHeader": True, "separator": ",", "optimizePerformance": False},
    connection_type="s3",
    format="csv",
    connection_options={
        "paths": [f"s3://{bucket}/{bucket_key}"],
        "recurse": True
    },
    transformation_ctx="AmazonS3_node"
)

# Convert Glue DynamicFrame to Spark DataFrame
spark_df = AmazonS3_node.toDF()

# Convert Spark DataFrame to Pandas DataFrame for transformation
pandas_df = spark_df.toPandas()



#==ここにpandasの処理を入れる==
# class_2y_string列を整数に変換して2倍にする
if 'class_2y_string' in pandas_df.columns:
    pandas_df['class_2y_string'] = pandas_df['class_2y_string'].astype(int) * 2

# class_4y_string列をすべて0にする
if 'class_4y_string' in pandas_df.columns:
    pandas_df['class_4y_string'] = 0

# Rename columns to English
english_columns = [
    "id", "entity", "nursery_name", "location", "phone_number", "opening_date",
    "age_min", "age_max", "class_0y", "class_1y", "class_2y", "class_3y",
    "class_4y", "class_5y", "total_children", "start_time", "end_time",
    "extended_start_time", "extended_end_time", "extended_age", "operator"
]
pandas_df.columns = english_columns

# class_2y_string列を整数に変換して2倍にする
if 'class_2y' in pandas_df.columns:
    pandas_df['class_2y'] = pandas_df['class_2y'].astype(int) * 2

# class_4y_string列をすべて0にする
if 'class_4y' in pandas_df.columns:
    pandas_df['class_4y'] = 0

# 変更後のカラム名を出力
print("Modified column names:", pandas_df.columns.tolist())

# データの先頭5行を出力
print("Data sample:")
print(pandas_df.head())
#==ここにpandasの処理を入れる==



# Convert Pandas DataFrame back to Spark DataFrame
modified_spark_df = spark.createDataFrame(pandas_df)

# Finally, convert Spark DataFrame back to Glue DynamicFrame
modified_dynamic_frame = DynamicFrame.fromDF(modified_spark_df, glueContext, "modified_df")

# Script generated for node Amazon Redshift
AmazonRedshift_node = glueContext.write_dynamic_frame.from_options(
    frame=modified_dynamic_frame,
    connection_type="redshift",
    connection_options={
        "redshiftTmpDir": "s3://glue-temp-941996685139/redshift_temporary/",
        "useConnectionProperties": "true",
        "dbtable": "public.nursery_info",
        "connectionName": "Redshift Serverless Connection",
        "preactions": """
            CREATE TABLE IF NOT EXISTS public.nursery_info (
                id BIGINT,
                entity VARCHAR,
                nursery_name VARCHAR,
                location VARCHAR,
                phone_number VARCHAR,
                opening_date VARCHAR,
                age_min BIGINT,
                age_max BIGINT,
                class_0y BIGINT,
                class_1y BIGINT,
                class_2y BIGINT,
                class_3y BIGINT,
                class_4y BIGINT,
                class_5y BIGINT,
                total_children BIGINT,
                start_time VARCHAR,
                end_time VARCHAR,
                extended_start_time VARCHAR,
                extended_end_time VARCHAR,
                extended_age VARCHAR,
                operator VARCHAR
            );
        """
    },
    transformation_ctx="AmazonRedshift_node"
)

job.commit()