/*
<div>
    <input type="file" id="input-tag">
</div>
*/

(function($){
    let key,policy,signature,store_dir,upload_date,upload_time;
    $(`#input-tag`).fileupload({
        url: `https://<our bucket>.s3.amazonaws.com`,
        dataType: 'multipart/form-data',
        add: function (e, data) {
          $.ajax({
            url: `<some url endpoint>`,
            data: {'Authorization': `Bearer <some token>`},
            type: 'POST',
            success: (amz_data) => {
                this.key = amz_data.key;
                this.policy = amz_data.policy;
                this.signature = amz_data.signature;
                this.store_dir = amz_data.store;
                this.upload_time = amz_data.time;
                this.upload_date = amz_data.time_date;
                data.submit();
            },
            error: (error) => {
                console.log(error);
            }
          });
        },
        submit: (e, data) => {
          data.formData = {key:`${this.store_dir}/img.png`, "Policy":this.policy,"X-Amz-Signature":this.signature,"X-Amz-Credential":`${this.key}/${this.upload_date}/us-west-2/s3/aws4_request`,"X-Amz-Algorithm":"AWS4-HMAC-SHA256", "X-Amz-Date":this.upload_time, "acl": "public-read"};
        },
        progress: (e, data) => {
          let progress = Math.floor(((parseInt(data.loaded)*0.9)  / (parseInt(data.total))) * 100);
          console.log(progress);
        },
        done: (e, data) => {
            console.log('great success 100%!');
            if(e) console.log(e);
        }
    });
})($)