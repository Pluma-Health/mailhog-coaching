{{/*

Copyright 2023-2025 Skillsoft
All right reserved
Version: 0.1.0

NOTICE: THIS IS MANAGED FILE, DO NOT EDIT OR CHANGE
If you need to change or add, please create a new TPL file.
For information on these Helper functions, please see more at:
https://github.skillsoft.com/DevOps-chapter/helm-library

*/}}

{{/*
Region Fullname
*/}}
{{- define "skillsoft.region_name.full" }}
    {{- if contains "awsusw2" .Values.environment.name }}
        {{- "us-west-2" }}
    {{- else if contains "awseuw1" .Values.environment.name }}
        {{- "eu-west-1" }}
    {{- else if or (eq "awseu" .Values.environment.name) (eq "awseuc1-dmz" .Values.environment.name) }}
        {{- "eu-central-1" }}
    {{- else }}
        {{- "us-east-1" }}
    {{- end }}
{{- end }}


{{/*
Region Shortname
*/}}
{{- define "skillsoft.region_name.short" }}
    {{- if contains "awsusw2" .Values.environment.name }}
        {{- "usw2" }}
    {{- else if contains "awseuw1" .Values.environment.name }}
        {{- "euw1" }}
    {{- else if or (eq "awseu" .Values.environment.name) (eq "awseuc1-dmz" .Values.environment.name) }}
        {{- "euc1" }}
    {{- else }}
        {{- "use1" }}
    {{- end }}
{{- end }}


{{/*
ecr.repository
Echos out the proper ECR URL including the environment's full region name including Repository Name.
To override to use a local repository for a locally built image, override the image.repoUrl
as your local Repository name and image.containerTag as your new container tag.
EX:
helm template .\deployment\ -f .\deployment\values.yaml -f .\deployment\profiles\develop\values.yaml \
    --set image.repoUrl=My-New-Site-Shutdown \
    --set image.containerTag=bulid-123abc
*/}}
{{- define "skillsoft.ecr.repository" -}}
    {{- if .Values.image.repoUrl -}}
        {{- .Values.image.repoUrl -}}
    {{- else -}}
        {{- printf "510467250861.dkr.ecr.%s.amazonaws.com/%s" ( include "skillsoft.region_name.full" . ) .Values.image.repoName -}}
    {{- end -}}
{{- end -}}


{{- define "skillsoft.aws.arn.policy" -}}
    {{- printf "arn:aws:iam::%s:policy/%s%s" ( .Values.environment.awsAccountId ) ( include "skillsoft.percipio.prefix" . ) .Chart.Name -}}-policy
{{- end -}}

{{- define "skillsoft.aws.role.arn" -}}
    {{- if contains "develop" .Values.environment.name }}
        {{- printf "arn:aws:iam::%v:role/%v-%s%s" .Values.environment.awsAccountId .Values.environment.awsAccountId ( include "skillsoft.percipio.prefix" . ) .Chart.Name -}}
    {{- else }}
        {{- printf "arn:aws:iam::%s:role/%s%s" ( .Values.environment.awsAccountId ) ( include "skillsoft.percipio.prefix" . ) .Chart.Name -}}-role
    {{- end }}
{{- end -}}

{{- define "skillsoft.aws.role.name" }}
    {{- if contains "develop" .Values.environment.name }}
        {{- printf "%v-%s%s" .Values.environment.awsAccountId ( include "skillsoft.percipio.prefix" . ) .Chart.Name -}}
    {{- else }}
        {{- printf "%s%s" ( include "skillsoft.percipio.prefix" . ) .Chart.Name -}}
    {{- end }}
{{- end }}

{{- define "skillsoft.eks.serviceaccount.name" }}
    {{- printf "%s%s" .Chart.Name "-serviceaccount" -}}
{{- end }}


{{- define "skillsoft.percipio.prefix" }}
    {{- if contains "develop" .Values.environment.name }}
        {{- "use1-develop-" }}
    {{- else if contains "awsdev" .Values.environment.name }}
        {{- "use1-develop-" }}
    {{- else if contains "awsmas" .Values.environment.name }}
        {{- "use1-master-" }}
    {{- else if contains "awsstg" .Values.environment.name }}
        {{- "use1-stage-" }}
    {{- else if contains "awseuw1" .Values.environment.name }}
        {{- "euw1-prod-" }}
    {{- else if contains "awseu" .Values.environment.name }}
        {{- "euc1-prod-" }}
    {{- else if contains "awsusw2" .Values.environment.name }}
        {{- "usw2-prod-" }}
    {{- else if contains "awsprod" .Values.environment.name }}
        {{- "use1-prod-" }}
    {{- else }}
        {{- "use1-develop-" }}
    {{- end }}
{{- end }}

{{/*
S3 Bucket Prefix
Creates a prefix for S3 buckets following the pattern <AWS Account Number>-<Region>-<Chart Name>

Example:
- With awsAccountId = "123456789012"
- environment.region = "use1"
- Chart.Name = "my-service"

The rendered prefix would be: "123456789012-use1-my-service"

This will result in a final bucket name like: ssoft-123456789012-us-east-1-my-service-my-bucket

!NOTE!

Once IACv2 becomes live across all environments and fully switched over, we will be able
to eliminate all the if clauses and only have a single template because the new format will
work for all IACv2 deployments, there will be no need for the complex logic below.
*/}}

{{- define "skillsoft.s3.bucketname" }}
    {{- if contains "develop" .Values.environment.name }}
        {{- printf "%v-%s-%s" .Values.environment.awsAccountId .Values.environment.region .Chart.Name -}}
    {{- else if contains "awsdev" .Values.environment.name }}
        {{- printf "ssoft-use1-develop-%s" ( .Values.s3.bucket_suffix ) -}}
    {{- else if contains "awsmas" .Values.environment.name }}
        {{- printf "ssoft-use1-master-%s" ( .Values.s3.bucket_suffix ) -}}
    {{- else if contains "awsstg" .Values.environment.name }}
        {{- printf "ssoft-use1-stage-%s" ( .Values.s3.bucket_suffix ) -}}
    {{- else if contains "awseuw1" .Values.environment.name }}
        {{- printf "ssoft-euw1-prod-%s" ( .Values.s3.bucket_suffix ) -}}
    {{- else if contains "awseu" .Values.environment.name }}
        {{- printf "ssoft-euc1-prod-%s" ( .Values.s3.bucket_suffix ) -}}
    {{- else if contains "awsusw2" .Values.environment.name }}
        {{- printf "ssoft-usw2-prod-%s" ( .Values.s3.bucket_suffix ) -}}
    {{- else if contains "awsprod" .Values.environment.name }}
        {{- printf "ssoft-use1-prod-%s" ( .Values.s3.bucket_suffix ) -}}
    {{- else }}
        {{- printf "ssoft-use1-develop-%s" ( .Values.s3.bucket_suffix ) -}}
    {{- end }}
{{- end }}

