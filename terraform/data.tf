data "http" "outgoing_ip" {
    url = "https://ifconfig.me"
}

locals {
    outgoing_ip = chomp(data.http.outgoing_ip.response_body)
    repo_path   = abspath(format("%s/..", path.module))
}