# -*- coding: utf-8 -*-
#
# Copyright 2013 whiteleaf. All rights reserved.
#

require "win32ole"
require_relative "../../extensions/windows"

module Device::Library
  module Windows
    def get_device_root_dir(volume_name)
      @@FileSystemObject ||= WIN32OLE.new("Scripting.FileSystemObject")
      drive_strings = " " * 1000
      result_len = WinAPI.GetLogicalDriveStrings(1000, drive_strings)
      drives = drive_strings[0, result_len].split("\0")
      drives.each do |drive_letter|
        drive_info = @@FileSystemObject.GetDrive(drive_letter)
        vol = drive_info.VolumeName rescue ""
        if vol.downcase == volume_name.downcase
          return File.expand_path(drive_letter)
        end
      end
      nil
    end
  end
end
