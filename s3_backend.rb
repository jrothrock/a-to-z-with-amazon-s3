    # we're doing some type of crud
        
    def create
    #... some stuff that went on above and we have an object = a song/video/image/csv/etc

        time = Time.now.utc
        render :json => {
						:policy => string_to_sign(time),
						:signature => sig(time),
						:key => Rails.application.secrets.aws_access_key_id,
						:store=> "uploads/#{object.url}",
						:time => time.strftime('%Y%m%dT000000Z'),
						:time_date => time.strftime('%Y%m%d')
					}
    end 

    def string_to_sign(time)

		time_policy = time.strftime('%Y%m%dT000000Z')
		date_stamp = time.strftime('%Y%m%d')

		 ret = {"expiration" => 10.hours.from_now.utc.iso8601,
				"conditions" =>  [
					{"bucket" => Rails.application.secrets.aws_bucket},
					{"x-amz-credential": "#{Rails.application.secrets.aws_access_key_id}/#{date_stamp}/us-west-2/s3/aws4_request"},
					{"x-amz-algorithm": "AWS4-HMAC-SHA256"},
					{"x-amz-date": time_policy },
					["starts-with", "$key", "uploads"], 
					["content-length-range", 0, 2147483648]
				]
			}

		return policy = Base64.encode64(ret.to_json).gsub(/\n|\r/, '')

	end

	def getSignatureKey(time)
        date_stamp = time.strftime('%Y%m%d')
		kDate = OpenSSL::HMAC.digest('sha256', ("AWS4" +  Rails.application.secrets.aws_secret_access_key), date_stamp)
		kRegion = OpenSSL::HMAC.digest('sha256', kDate, 'us-west-2')
		kService = OpenSSL::HMAC.digest('sha256', kRegion, 's3')
		return kSigning = OpenSSL::HMAC.digest('sha256', kService, "aws4_request")
	end

	def sig(time)
		return sig = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), getSignatureKey(time), string_to_sign(time)).gsub(/\n|\r/, '')
	end