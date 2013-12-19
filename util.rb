class Util
    def Util.gunzip(data)
        sio = StringIO.new(data)
        gz = Zlib::GzipReader.new(sio)
        read_data = gz.read
        gz.close
        return read_data
    end
end