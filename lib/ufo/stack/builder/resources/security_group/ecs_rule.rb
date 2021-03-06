module Ufo::Stack::Builder::Resources::SecurityGroup
  class EcsRule < Base
    def build
      return unless managed_security_groups_enabled?
      return unless @elb_type == "application"

      {
        Type: "AWS::EC2::SecurityGroupIngress",
        Condition: "CreateElbIsTrue",
        Properties: {
          IpProtocol: "tcp",
          FromPort: "0",
          ToPort: "65535",
          SourceSecurityGroupId: {
            "Fn::GetAtt": "ElbSecurityGroup.GroupId"
          },
          GroupId: {
            "Fn::GetAtt": "EcsSecurityGroup.GroupId"
          },
          Description: "application elb access to ecs"
        }
      }
    end
  end
end
