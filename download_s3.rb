#!/usr/bin/env ruby
require "rubygems"
require "aws-sdk"
require "inifile"
require "csv"
require File.dirname(__FILE__) + '/Util.rb'

bucket_name = ARGV[0]
file_prefix = ARGV[1]
out_path    = ARGV[2]


config = IniFile.load(File.dirname(__FILE__) + "/aws.ini")

s3 = AWS::S3.new(
        :access_key_id => config[bucket_name]["aws_access_key_id"], 
        :secret_access_key => config[bucket_name]["aws_secret_access_key"]
    )

CSV.open(out_path, "wb") do |csv|
    s3.buckets[bucket_name].objects.with_prefix(file_prefix).each() do |file|
        text = Util.gunzip(file.read)
        text.each_line do |line|
            json = JSON.parse(line.split("\t")[2])
            csv_arr = []
            json.each_value do |val|
                csv_arr.push(val)
            end
            csv << csv_arr
        end
    end
end
