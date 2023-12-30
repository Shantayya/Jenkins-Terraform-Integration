variable "statefile" {
  default = "statefile-2023"
}

variable "statelock" {
  default = "statelock-2023"
}

variable "username" {
  default = "admin"
}

variable "pass" {
  default   = "admin123"
  sensitive = true
}

variable "region" {
  default = "ap-south-1"
}

variable "key" {
  default = "LockID"
}