output "aws_vpc" {
    value = aws_vpc.ecsvpc.id
  
}

output "aws_internet_gateway" {
    value = aws_internet_gateway.igw.id
  
}

output "aws_nat_gateway" {
    value = aws_nat_gateway.nateip1
}
