# data "aws_route53_zone" "primary" {
#   name         = "${var.profile}.anushakadali.me"
# }

# resource "aws_route53_record" "new_record" {
#   zone_id = data.aws_route53_zone.primary.zone_id
#   name    = data.aws_route53_zone.primary.name
#   type    = "A"
#   ttl     = 300
#   records = [aws_instance.app_instance.public_ip]
# }