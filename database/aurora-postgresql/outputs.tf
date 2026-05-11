output "cluster_endpoint" {
  description = "The cluster endpoint"
  value       = aws_rds_cluster.this.endpoint
}

output "cluster_reader_endpoint" {
  description = "The cluster reader endpoint"
  value       = aws_rds_cluster.this.reader_endpoint
}

output "cluster_arn" {
  description = "The ARN of the cluster"
  value       = aws_rds_cluster.this.arn
}

output "cluster_id" {
  description = "The ID of the cluster"
  value       = aws_rds_cluster.this.cluster_identifier
}
