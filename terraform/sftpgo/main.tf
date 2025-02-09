resource "sftpgo_group" "sftpgo-users" {
  name = "sftpgo-users"
  user_settings = {
    filesystem = {
      provider = 0 # local filesystem
    }

    permissions = {
      "/" = "list,download"
    }
  }
  virtual_folders = [
    {
      name         = "homedir-users"
      quota_files  = -1
      quota_size   = -1
      virtual_path = "/"
      mapped_path  = "/data"
    }
  ]
}

resource "sftpgo_group" "sftpgo-sysops" {
  name = "sftpgo-sysops"
  user_settings = {
    filesystem = {
      provider = 0 # local filesystem
    }

    permissions = {
      "/" = "*"
    }
  }
  virtual_folders = [
    {
      name         = "homedir-sysops"
      quota_files  = -1
      quota_size   = -1
      virtual_path = "/"
      mapped_path  = "/data"
    }
  ]
}
