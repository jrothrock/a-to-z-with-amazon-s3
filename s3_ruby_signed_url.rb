# key = "AKIAJB4CZKBIMMAYRNCQ"
# secret = "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"
# credentials = Aws::Credentials.new(key, secret)
# client = Aws::S3::Client.new(
#     region: "us-west-2",
#     credentials: credentials
# )
# signer = Aws::S3::Presigner.new(:client=>client)
# url = signer.presigned_url(:get_object, response_content_disposition:"attachment; filename=img.png", bucket: "jackrothrock-test", key: "uploads/img.png",:expires_in=>600)

Aws::S3::Presigner.new(:client=>Aws::S3::Client.new(region: "us-west-2",credentials:Aws::Credentials.new("AKIAI3P42MDH6V2ZUKVA", "Ovkf1OBMQV7zzpApVveN7OdpZyMWm8V+v7CkmAb1"))).presigned_url(:get_object, response_content_disposition:"attachment; filename=img.png", bucket: "jackrothrock-test", key: "uploads/img.png",:expires_in=>600)