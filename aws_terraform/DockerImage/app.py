import boto3
from flask import Flask
app = Flask(__name__)

@app.route('/ec2')
def ec2_instance():
    result = []
    AWS_REGION = request.args["aws_region"]
    EC2_RESOURCE = boto3.resource('ec2', region_name=AWS_REGION)
    
    instances = EC2_RESOURCE.instances.all()

    for instance in instances:
        instance_id = instance.id
        instance_state = instance.state["Name"]
        instance_public_ip = instance.public_ip_address
        result.append([instance_id,instance_state,instance_public_ip])

    return make_response(jsonify(result), 200)    

if __name__ == "__main__":
    app.run(host='0.0.0.0')
