variable "sweety" {
  type = list(string)
  default = [ "juice","bread","jam" ] #if one value removed the symmetric deletion takes place
  #example if we delete bread then jam gets deleted and the jam gets bread name 
}