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
      name         = "media-dir"
      quota_files  = -1
      quota_size   = -1
      virtual_path = "/"
    }
  ]
  depends_on = [sftpgo_folder.media-dir]
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
      name         = "media-dir"
      quota_files  = -1
      quota_size   = -1
      virtual_path = "/"
    }
  ]
  depends_on = [sftpgo_folder.media-dir]
}

resource "sftpgo_folder" "media-dir" {
  name = "media-dir"

  filesystem = {
    provider = 0 # local filesystem
  }
  mapped_path = "/data"
}
