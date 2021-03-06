classdef world
    properties
        child; robot; time; cube1; cube2; cube3; cube4; map; Smap;
    end
    
    methods
        function obj = world(state)
            obj.time = 0;
            Smap = load('S');
            Smap = num2str(Smap.S);
            
            %child's characteristics
            obj.child.head_angle = -pi/2; %!!! not changed?
            obj.child.head_radius = 1.4;
            obj.child.head_pos = [0 3];
            obj.child.head_color = [0.95 0.95 1];
            obj.child.head_action_param = 0;
            obj.child.head_angle_des = -pi/2; %!!
            
            %robot's characteristics
            obj.robot.head_angle_des = pi/2;
            obj.robot.head_angle = pi/4;
            obj.robot.head_radius = 1.4;
            obj.robot.head_pos = [0 -5];
            obj.robot.head_color = [1 1 1];
            obj.robot.bicep_length = 2.2;
            obj.robot.forearm_length = 1.6;
            obj.robot.shoulder_radius = 0.6;
            obj.robot.elbow_radius = 0.5;
            obj.robot.fist_radius = 0.5;
            obj.robot.right_shoulder_pos = obj.robot.head_pos + [1.3*obj.robot.head_radius 0];
            obj.robot.left_shoulder_pos  = obj.robot.head_pos - [1.3*obj.robot.head_radius 0];
            
            obj.robot.right_arm_pos_rest =  [obj.robot.head_radius, -3];
            obj.robot.right_arm_pos = obj.robot.right_arm_pos_rest;
            obj.robot.right_arm_pos_des = obj.robot.right_arm_pos;
            
            obj.robot.left_arm_pos_rest =  [-obj.robot.head_radius, -3];
            obj.robot.left_arm_pos = obj.robot.left_arm_pos_rest;
            obj.robot.left_arm_pos_des = obj.robot.left_arm_pos;
            
            obj.robot.right_action_param = 0;
            obj.robot.left_action_param = 0;
            
            obj.robot.right_grasp = 0;
            obj.robot.left_grasp = 0;
            
            obj.robot.head_action_param = 0.5;
            obj.map.pos1 = [-1.2 -2.1];
            obj.map.pos2 = [0 -1.2];
            obj.map.pos3 = [1.2 -2.1];
            %obj.map.pos4 = [4.3 -2.3];
            
            obj.robot.pos0 = [0 -1];
            obj.robot.pos1 = [2 -1];
            obj.robot.pos2 = [0.8 -1.5];
            obj.robot.pos3 = [-1.3 -1];
            %obj.robot.pos4 = [-3 -1];
            
            
            obj.cube1.color = [ 1 0.5 1 ];
            obj.cube1.size = 0.3;
            obj.cube1.grasped_right = 0;
            obj.cube1.grasped_left = 0;
            
            obj.cube2.color = [1 0 0];
            obj.cube2.size = 0.4;
            obj.cube2.grasped_right = 0;
            obj.cube2.grasped_left = 0;
            
            obj.cube3.color = [0.5 1 0.5];
            obj.cube3.size = 0.5;
            obj.cube3.grasped_right = 0;
            obj.cube3.grasped_left = 0;
                        
            
            S = Smap(state,:);
            obj.map.layer1 = [0 0 0];
            obj.map.layer2 = [0 0 0];
            obj.map.layer3 = [0 0 0];
            p1 = find(S=='1');
            if p1<=3
                obj.cube1.pos=obj.map.pos1;
                if p1==3
                    obj.cube1.accessible = true;
                    obj.map.layer3(1) = 1;
                elseif p1==2
                    obj.cube1.accessible = false;
                    obj.map.layer2(1) = 1;
                elseif p1==1
                    obj.cube1.accessible = false;
                    obj.map.layer1(1) = 1;
                end
            elseif p1<=8
                obj.cube1.pos = obj.map.pos2;
                if p1==8
                    obj.cube1.accessible = true;
                    obj.map.layer3(2) = 1;
                elseif p1==7
                    obj.cube1.accessible = false;
                    obj.map.layer2(2) = 1;
                elseif p1==6
                    obj.cube1.accessible = false;
                    obj.map.layer1(2) = 1;
                end
            elseif p1<=13
                obj.cube1.pos=obj.map.pos3;
                if p1==13
                    obj.cube1.accessible = true;
                    obj.map.layer3(3) = 1;
                elseif p1==12
                    obj.cube1.accessible = false;
                    obj.map.layer2(3) = 1;
                elseif p1==11
                    obj.cube1.accessible = false;
                    obj.map.layer1(3) = 1;
                end
            end
            
            p2 = find(S=='2');
            if p2<=3
                obj.cube2.pos=obj.map.pos1;
                if p2==3
                    obj.cube2.accessible = true;
                    obj.map.layer3(1) = 2;
                elseif p2==2
                    obj.cube2.accessible = false;
                    obj.map.layer2(1) = 2;
                elseif p2==1
                    obj.cube2.accessible = false;
                    obj.map.layer1(1) = 2;
                end
            elseif p2<=8
                obj.cube2.pos=obj.map.pos2;
                if p2==8
                    obj.cube2.accessible = true;
                    obj.map.layer3(2) = 2;
                elseif p2==7
                    obj.cube2.accessible = false;
                    obj.map.layer2(2) = 2;
                elseif p2==6
                    obj.cube2.accessible = false;
                    obj.map.layer1(2) = 2;
                end
            elseif p2<=13
                obj.cube2.pos=obj.map.pos3;
                if p2==13
                    obj.cube2.accessible = true;
                    obj.map.layer3(3) = 2;
                elseif p2==12
                    obj.cube2.accessible = false;
                    obj.map.layer2(3) = 2;
                elseif p2==11
                    obj.cube2.accessible = false;
                    obj.map.layer1(3) = 2;
                end
            end
            
            p3 = find(S=='3');
            if p3<=3
                obj.cube3.pos=obj.map.pos1;
                if p3==3
                    obj.cube3.accessible = true;
                    obj.map.layer3(1) = 3;
                elseif p3==2
                    obj.cube3.accessible = false;
                    obj.map.layer2(1) = 3;
                elseif p3==1
                    obj.cube3.accessible = false;
                    obj.map.layer1(1) = 3;
                end
            elseif p3<=8
                obj.cube3.pos=obj.map.pos2;
                if p3==8
                    obj.cube3.accessible = true;
                    obj.map.layer3(2) = 3;
                elseif p3==7
                    obj.cube3.accessible = false;
                    obj.map.layer2(2) = 3;
                elseif p3==6
                    obj.cube3.accessible = false;
                    obj.map.layer1(2) = 3;
                end
            elseif p3<=13
                obj.cube3.pos=obj.map.pos3;
                if p3==13
                    obj.cube3.accessible = true;
                    obj.map.layer3(3) = 3;
                elseif p3==12
                    obj.cube3.accessible = false;
                    obj.map.layer2(3) = 3;
                elseif p3==11
                    obj.cube3.accessible = false;
                    obj.map.layer1(3) = 3;
                end
            end
            
            
            
        end
        
        function visualize(obj)
            drawstate(obj);
        end
        
        function obj = robotAction(obj, act, param, varargin)
            if nargin<4
                eng = 10;
            else
                eng = varargin{1};
            end
            p = 0.15 + 0.6*((param-100)/200+1);
            a = 1/p;
            beta = 0.2;
            gamma = 0.4;
            sig = -pi*(eng-10)/20;
            sig = min(sig, pi/2.5);
            sgn = 2*(randn>-1)-1;
            sig= sgn*sig;
            switch act
                % ACTION 1 %%%%%%%%%%%%%%%%%
                case 1
                    % approach pos1...
                    obj.robot.head_angle_des = atan2(obj.map.pos1(2)-obj.robot.head_pos(2),obj.map.pos1(1)-obj.robot.head_pos(1));
                    while norm(obj.map.pos1 - obj.robot.left_arm_pos)>0.01
                        obj.robot.left_arm_pos = (1-p)*obj.robot.left_arm_pos + p*obj.map.pos1;
                        obj.robot.head_angle = (1-a*p)*obj.robot.head_angle + a*p*obj.robot.head_angle_des;
                        obj.robot.right_arm_pos = (1-p)*obj.robot.right_arm_pos + p*obj.robot.right_arm_pos_rest; %also move the other to rest..
                        
                        if rand>gamma
                            poi = obj.robot.left_arm_pos; %point of interest;
                            sample = datasample([0.1*randn-sig 0.1*randn+sig],1);
                            sample = datasample([0.1*randn-sig],1);
                            theta = atan2(poi(2)-obj.child.head_pos(2), poi(1)-obj.child.head_pos(1));
                            obj.child.head_angle = (1-beta)*obj.child.head_angle + beta*(theta+sample);
                        end
                        drawstate(obj);
                    end
                    %grab what can be grabed there...
                    obj.cube1.grabbed = false;
                    obj.cube2.grabbed = false;
                    obj.cube3.grabbed = false;
                    
                    if ismember(1,obj.map.layer3)&&(norm(obj.cube1.pos-obj.map.pos1)<0.1)
                        obj.cube1.grabbed = true;
                    elseif ismember(2,obj.map.layer3)&&(norm(obj.cube2.pos-obj.map.pos1)<0.1)
                        obj.cube2.grabbed = true;
                    elseif ismember(3,obj.map.layer3)&&(norm(obj.cube3.pos-obj.map.pos1)<0.1)
                        obj.cube3.grabbed = true;
                    end
                    %go to center position
                    obj.robot.head_angle_des = atan2(obj.map.pos2(2)-obj.robot.head_pos(2),obj.map.pos2(1)-obj.robot.head_pos(1));
                    while norm(obj.map.pos2 - obj.robot.left_arm_pos)>0.01
                        obj.robot.left_arm_pos = (1-p)*obj.robot.left_arm_pos + p*obj.map.pos2;
                        obj.robot.head_angle = (1-a*p)*obj.robot.head_angle + a*p*obj.robot.head_angle_des;
                        obj.robot.right_arm_pos = (1-p)*obj.robot.right_arm_pos + p*obj.robot.right_arm_pos_rest; %also move the other to rest..
                        if obj.cube1.grabbed
                            obj.cube1.pos = obj.robot.left_arm_pos;
                        elseif obj.cube2.grabbed
                            obj.cube2.pos = obj.robot.left_arm_pos;
                        elseif obj.cube3.grabbed
                            obj.cube3.pos = obj.robot.left_arm_pos;
                        end
                        if rand>gamma
                            poi = obj.robot.left_arm_pos; %point of interest;
                            sample = datasample([0.1*randn-sig 0.1*randn+sig],1);
                            sample = datasample([0.1*randn-sig],1);
                            theta = atan2(poi(2)-obj.child.head_pos(2), poi(1)-obj.child.head_pos(1));
                            obj.child.head_angle = (1-beta)*obj.child.head_angle + beta*(theta+sample);
                        end
                        drawstate(obj);
                    end
                    if obj.cube1.grabbed
                        obj.cube1.grabbed = false;
                        obj.map.layer3(1) = obj.map.layer2(1);
                        obj.map.layer2(1) = obj.map.layer1(1);
                        obj.map.layer1(1) = 0;
                        obj.map.layer1(2) = obj.map.layer2(2);
                        obj.map.layer2(2) = obj.map.layer3(2);
                        obj.map.layer3(2) = 1;
                    elseif obj.cube2.grabbed
                        obj.cube2.grabbed = false;
                        obj.map.layer3(1) = obj.map.layer2(1);
                        obj.map.layer2(1) = obj.map.layer1(1);
                        obj.map.layer1(1) = 0;
                        obj.map.layer1(2) = obj.map.layer2(2);
                        obj.map.layer2(2) = obj.map.layer3(2);
                        obj.map.layer3(2) = 2;
                    elseif obj.cube3.grabbed
                        obj.cube3.grabbed = false;
                        obj.map.layer3(1) = obj.map.layer2(1);
                        obj.map.layer2(1) = obj.map.layer1(1);
                        obj.map.layer1(1) = 0;
                        obj.map.layer1(2) = obj.map.layer2(2);
                        obj.map.layer2(2) = obj.map.layer3(2);
                        obj.map.layer3(2) = 3;
                    end
                    %return to rest position
                    %action done here....! can use a flag
                    obj.robot.left_arm_pos_des = obj.robot.left_arm_pos_rest;
                    while norm(obj.robot.left_arm_pos - obj.robot.left_arm_pos_des)>0.01
                        obj.robot.left_arm_pos = (1-p)*obj.robot.left_arm_pos + p*obj.robot.left_arm_pos_des;
                        drawstate(obj);
                        if norm(obj.robot.left_arm_pos_rest - obj.robot.left_arm_pos)<1.5
                            %%actiondone = true;
                            break;
                        end
                    end
                    % ACTION 2 %%%%%%%%%%%%%%%%%
                case 6 %old 2 new 6
                    % approach pos3...
                    obj.robot.head_angle_des = atan2(obj.map.pos3(2)-obj.robot.head_pos(2),obj.map.pos3(1)-obj.robot.head_pos(1));
                    while norm(obj.map.pos3 - obj.robot.right_arm_pos)>0.01
                        obj.robot.right_arm_pos = (1-p)*obj.robot.right_arm_pos + p*obj.map.pos3;
                        obj.robot.head_angle = (1-a*p)*obj.robot.head_angle + a*p*obj.robot.head_angle_des;
                        obj.robot.left_arm_pos = (1-p)*obj.robot.left_arm_pos + p*obj.robot.left_arm_pos_rest; %also move the other to rest..
                        
                        if rand>gamma
                            poi = obj.robot.right_arm_pos; %point of interest;
                            sample = datasample([0.1*randn-sig 0.1*randn+sig],1);
                            sample = datasample([0.1*randn-sig],1);
                            theta = atan2(poi(2)-obj.child.head_pos(2), poi(1)-obj.child.head_pos(1));
                            obj.child.head_angle = (1-beta)*obj.child.head_angle + beta*(theta+sample);
                        end
                        drawstate(obj);
                    end
                    %grab what can be grabed there...
                    obj.cube1.grabbed = false;
                    obj.cube2.grabbed = false;
                    obj.cube3.grabbed = false;
                    
                    if ismember(1,obj.map.layer3)&&(norm(obj.cube1.pos-obj.map.pos3)<0.1)
                        obj.cube1.grabbed = true;
                    elseif ismember(2,obj.map.layer3)&&(norm(obj.cube2.pos-obj.map.pos3)<0.1)
                        obj.cube2.grabbed = true;
                    elseif ismember(3,obj.map.layer3)&&(norm(obj.cube3.pos-obj.map.pos3)<0.1)
                        obj.cube3.grabbed = true;
                    end
                    %go to center position
                    obj.robot.head_angle_des = atan2(obj.map.pos2(2)-obj.robot.head_pos(2),obj.map.pos2(1)-obj.robot.head_pos(1));
                    while norm(obj.map.pos2 - obj.robot.right_arm_pos)>0.01
                        obj.robot.right_arm_pos = (1-p)*obj.robot.right_arm_pos + p*obj.map.pos2;
                        obj.robot.head_angle = (1-a*p)*obj.robot.head_angle + a*p*obj.robot.head_angle_des;
                        obj.robot.left_arm_pos = (1-p)*obj.robot.left_arm_pos + p*obj.robot.left_arm_pos_rest; %also move the other to rest..
                        if obj.cube1.grabbed
                            obj.cube1.pos = obj.robot.right_arm_pos;
                        elseif obj.cube2.grabbed
                            obj.cube2.pos = obj.robot.right_arm_pos;
                        elseif obj.cube3.grabbed
                            obj.cube3.pos = obj.robot.right_arm_pos;
                        end
                        
                        if rand>gamma
                            poi = obj.robot.right_arm_pos; %point of interest;
                            sample = datasample([0.1*randn-sig 0.1*randn+sig],1);
                            sample = datasample([0.1*randn-sig],1);
                            theta = atan2(poi(2)-obj.child.head_pos(2), poi(1)-obj.child.head_pos(1));
                            obj.child.head_angle = (1-beta)*obj.child.head_angle + beta*(theta+sample);
                        end
                        drawstate(obj);
                    end
                    if obj.cube1.grabbed
                        obj.cube1.grabbed = false;
                        obj.map.layer3(3) = obj.map.layer2(3);
                        obj.map.layer2(3) = obj.map.layer1(3);
                        obj.map.layer1(3) = 0;
                        obj.map.layer1(2) = obj.map.layer2(2);
                        obj.map.layer2(2) = obj.map.layer3(2);
                        obj.map.layer3(2) = 1;
                    elseif obj.cube2.grabbed
                        obj.cube2.grabbed = false;
                        obj.map.layer3(3) = obj.map.layer2(3);
                        obj.map.layer2(3) = obj.map.layer1(3);
                        obj.map.layer1(3) = 0;
                        obj.map.layer1(2) = obj.map.layer2(2);
                        obj.map.layer2(2) = obj.map.layer3(2);
                        obj.map.layer3(2) = 2;
                    elseif obj.cube3.grabbed
                        obj.cube3.grabbed = false;
                        obj.map.layer3(3) = obj.map.layer2(3);
                        obj.map.layer2(3) = obj.map.layer1(3);
                        obj.map.layer1(3) = 0;
                        obj.map.layer1(2) = obj.map.layer2(2);
                        obj.map.layer2(2) = obj.map.layer3(2);
                        obj.map.layer3(2) = 3;
                    end
                    %return to rest position
                    %action done here....! can use a flag
                    obj.robot.right_arm_pos_des = obj.robot.right_arm_pos_rest;
                    while norm(obj.robot.right_arm_pos - obj.robot.right_arm_pos_des)>0.01
                        obj.robot.right_arm_pos = (1-p)*obj.robot.right_arm_pos + p*obj.robot.right_arm_pos_des;
                        drawstate(obj);
                        if norm(obj.robot.right_arm_pos_rest - obj.robot.right_arm_pos)<1.5
                            %actiondone = true;
                            break;
                        end
                    end
                    
                % ACTION 3 %%%%%%%%%%%%%%%%%
                case 2
                    % approach pos1...
                    obj.robot.head_angle_des = atan2(obj.map.pos1(2)-obj.robot.head_pos(2),obj.map.pos1(1)-obj.robot.head_pos(1));
                    while norm(obj.map.pos1 - obj.robot.left_arm_pos)>0.01
                        obj.robot.left_arm_pos = (1-p)*obj.robot.left_arm_pos + p*obj.map.pos1;
                        obj.robot.head_angle = (1-a*p)*obj.robot.head_angle + a*p*obj.robot.head_angle_des;
                        obj.robot.right_arm_pos = (1-p)*obj.robot.right_arm_pos + p*obj.robot.right_arm_pos_rest; %also move the other to rest..
                        
                        if rand>gamma
                            poi = obj.robot.left_arm_pos; %point of interest;
                            sample = datasample([0.1*randn-sig 0.1*randn+sig],1);
                            sample = datasample([0.1*randn-sig],1);
                            theta = atan2(poi(2)-obj.child.head_pos(2), poi(1)-obj.child.head_pos(1));
                            obj.child.head_angle = (1-beta)*obj.child.head_angle + beta*(theta+sample);
                        end
                        drawstate(obj);
                    end
                    %grab what can be grabed there...
                    obj.cube1.grabbed = false;
                    obj.cube2.grabbed = false;
                    obj.cube3.grabbed = false;
                    
                    if ismember(1,obj.map.layer3)&&(norm(obj.cube1.pos-obj.map.pos1)<0.1)
                        obj.cube1.grabbed = true;
                    elseif ismember(2,obj.map.layer3)&&(norm(obj.cube2.pos-obj.map.pos1)<0.1)
                        obj.cube2.grabbed = true;
                    elseif ismember(3,obj.map.layer3)&&(norm(obj.cube3.pos-obj.map.pos1)<0.1)
                        obj.cube3.grabbed = true;
                    end
                    %go to center position
                    obj.robot.head_angle_des = atan2(obj.map.pos3(2)-obj.robot.head_pos(2),obj.map.pos3(1)-obj.robot.head_pos(1));
                    while norm(obj.map.pos3 - obj.robot.left_arm_pos)>0.01
                        obj.robot.left_arm_pos = (1-p)*obj.robot.left_arm_pos + p*obj.map.pos3;
                        obj.robot.head_angle = (1-a*p)*obj.robot.head_angle + a*p*obj.robot.head_angle_des;
                        obj.robot.right_arm_pos = (1-p)*obj.robot.right_arm_pos + p*obj.robot.right_arm_pos_rest; %also move the other to rest..
                        if obj.cube1.grabbed
                            obj.cube1.pos = obj.robot.left_arm_pos;
                        elseif obj.cube2.grabbed
                            obj.cube2.pos = obj.robot.left_arm_pos;
                        elseif obj.cube3.grabbed
                            obj.cube3.pos = obj.robot.left_arm_pos;
                        end
                        
                        if rand>gamma
                            poi = obj.robot.left_arm_pos; %point of interest;
                            sample = datasample([0.1*randn-sig 0.1*randn+sig],1);
                            sample = datasample([0.1*randn-sig],1);
                            theta = atan2(poi(2)-obj.child.head_pos(2), poi(1)-obj.child.head_pos(1));
                            obj.child.head_angle = (1-beta)*obj.child.head_angle + beta*(theta+sample);
                        end
                        drawstate(obj);
                    end
                    if obj.cube1.grabbed
                        obj.cube1.grabbed = false;
                        obj.map.layer3(1) = obj.map.layer2(1);
                        obj.map.layer2(1) = obj.map.layer1(1);
                        obj.map.layer1(1) = 0;
                        obj.map.layer1(3) = obj.map.layer2(3);
                        obj.map.layer2(3) = obj.map.layer3(3);
                        obj.map.layer3(3) = 1;
                    elseif obj.cube2.grabbed
                        obj.cube2.grabbed = false;
                        obj.map.layer3(1) = obj.map.layer2(1);
                        obj.map.layer2(1) = obj.map.layer1(1);
                        obj.map.layer1(1) = 0;
                        obj.map.layer1(3) = obj.map.layer2(3);
                        obj.map.layer2(3) = obj.map.layer3(3);
                        obj.map.layer3(3) = 2;
                    elseif obj.cube3.grabbed
                        obj.cube3.grabbed = false;
                        obj.map.layer3(1) = obj.map.layer2(1);
                        obj.map.layer2(1) = obj.map.layer1(1);
                        obj.map.layer1(1) = 0;
                        obj.map.layer1(3) = obj.map.layer2(3);
                        obj.map.layer2(3) = obj.map.layer3(3);
                        obj.map.layer3(3) = 3;
                    end
                    %return to rest position
                    %action done here....! can use a flag
                    obj.robot.left_arm_pos_des = obj.robot.left_arm_pos_rest;
                    while norm(obj.robot.left_arm_pos - obj.robot.left_arm_pos_des)>0.01
                        obj.robot.left_arm_pos = (1-p)*obj.robot.left_arm_pos + p*obj.robot.left_arm_pos_des;
                        drawstate(obj);
                        if norm(obj.robot.left_arm_pos_rest - obj.robot.left_arm_pos)<1.5
                            %actiondone = true;
                            break;
                        end
                    end
                % ACTION 4 %%%%%%%%%%%%%%%%%
                case 3 %old 4 new 3
                    % approach pos1...
                    obj.robot.head_angle_des = atan2(obj.map.pos2(2)-obj.robot.head_pos(2),obj.map.pos2(1)-obj.robot.head_pos(1));
                    while norm(obj.map.pos2 - obj.robot.left_arm_pos)>0.01
                        obj.robot.left_arm_pos = (1-p)*obj.robot.left_arm_pos + p*obj.map.pos2;
                        obj.robot.head_angle = (1-a*p)*obj.robot.head_angle + a*p*obj.robot.head_angle_des;
                        obj.robot.right_arm_pos = (1-p)*obj.robot.right_arm_pos + p*obj.robot.right_arm_pos_rest; %also move the other to rest..
                        
                        if rand>gamma
                            poi = obj.robot.left_arm_pos; %point of interest;
                            sample = datasample([0.1*randn-sig 0.1*randn+sig],1);
                            sample = datasample([0.1*randn-sig],1);
                            theta = atan2(poi(2)-obj.child.head_pos(2), poi(1)-obj.child.head_pos(1));
                            obj.child.head_angle = (1-beta)*obj.child.head_angle + beta*(theta+sample);
                        end
                        drawstate(obj);
                    end
                    %grab what can be grabed there...
                    obj.cube1.grabbed = false;
                    obj.cube2.grabbed = false;
                    obj.cube3.grabbed = false;
                    
                    if ismember(1,obj.map.layer3)&&(norm(obj.cube1.pos-obj.map.pos2)<0.1)
                        obj.cube1.grabbed = true;
                    elseif ismember(2,obj.map.layer3)&&(norm(obj.cube2.pos-obj.map.pos2)<0.1)
                        obj.cube2.grabbed = true;
                    elseif ismember(3,obj.map.layer3)&&(norm(obj.cube3.pos-obj.map.pos2)<0.1)
                        obj.cube3.grabbed = true;
                    end
                    %go to center position
                    obj.robot.head_angle_des = atan2(obj.map.pos1(2)-obj.robot.head_pos(2),obj.map.pos1(1)-obj.robot.head_pos(1));
                    while norm(obj.map.pos1 - obj.robot.left_arm_pos)>0.01
                        obj.robot.left_arm_pos = (1-p)*obj.robot.left_arm_pos + p*obj.map.pos1;
                        obj.robot.head_angle = (1-a*p)*obj.robot.head_angle + a*p*obj.robot.head_angle_des;
                        obj.robot.right_arm_pos = (1-p)*obj.robot.right_arm_pos + p*obj.robot.right_arm_pos_rest; %also move the other to rest..
                        if obj.cube1.grabbed
                            obj.cube1.pos = obj.robot.left_arm_pos;
                        elseif obj.cube2.grabbed
                            obj.cube2.pos = obj.robot.left_arm_pos;
                        elseif obj.cube3.grabbed
                            obj.cube3.pos = obj.robot.left_arm_pos;
                        end
                        if rand>gamma
                            poi = obj.robot.left_arm_pos; %point of interest;
                            sample = datasample([0.1*randn-sig 0.1*randn+sig],1);
                            sample = datasample([0.1*randn-sig],1);
                            theta = atan2(poi(2)-obj.child.head_pos(2), poi(1)-obj.child.head_pos(1));
                            obj.child.head_angle = (1-beta)*obj.child.head_angle + beta*(theta+sample);
                        end
                        drawstate(obj);
                    end
                    if obj.cube1.grabbed
                        obj.cube1.grabbed = false;
                        obj.map.layer3(2) = obj.map.layer2(2);
                        obj.map.layer2(2) = obj.map.layer1(2);
                        obj.map.layer1(2) = 0;
                        obj.map.layer1(1) = obj.map.layer2(1);
                        obj.map.layer2(1) = obj.map.layer3(1);
                        obj.map.layer3(1) = 1;
                    elseif obj.cube2.grabbed
                        obj.cube2.grabbed = false;
                        obj.map.layer3(2) = obj.map.layer2(2);
                        obj.map.layer2(2) = obj.map.layer1(2);
                        obj.map.layer1(2) = 0;
                        obj.map.layer1(1) = obj.map.layer2(1);
                        obj.map.layer2(1) = obj.map.layer3(1);
                        obj.map.layer3(1) = 2;
                    elseif obj.cube3.grabbed
                        obj.cube3.grabbed = false;
                        obj.map.layer3(2) = obj.map.layer2(2);
                        obj.map.layer2(2) = obj.map.layer1(2);
                        obj.map.layer1(2) = 0;
                        obj.map.layer1(1) = obj.map.layer2(1);
                        obj.map.layer2(1) = obj.map.layer3(1);
                        obj.map.layer3(1) = 3;
                    end
                    %return to rest position
                    %action done here....! can use a flag
                    obj.robot.left_arm_pos_des = obj.robot.left_arm_pos_rest;
                    while norm(obj.robot.left_arm_pos - obj.robot.left_arm_pos_des)>0.01
                        obj.robot.left_arm_pos = (1-p)*obj.robot.left_arm_pos + p*obj.robot.left_arm_pos_des;
                        drawstate(obj);
                        if norm(obj.robot.left_arm_pos_rest - obj.robot.left_arm_pos)<1.5
                            %actiondone = true;
                            break;
                        end
                    end
                % ACTION 5 %%%%%%%%%%%%%%%%%
                case 4 %old 5 new 4
                    % approach pos3...
                    obj.robot.head_angle_des = atan2(obj.map.pos2(2)-obj.robot.head_pos(2),obj.map.pos2(1)-obj.robot.head_pos(1));
                    while norm(obj.map.pos2 - obj.robot.right_arm_pos)>0.01
                        obj.robot.right_arm_pos = (1-p)*obj.robot.right_arm_pos + p*obj.map.pos2;
                        obj.robot.head_angle = (1-a*p)*obj.robot.head_angle + a*p*obj.robot.head_angle_des;
                        obj.robot.left_arm_pos = (1-p)*obj.robot.left_arm_pos + p*obj.robot.left_arm_pos_rest; %also move the other to rest..
                        
                        if rand>gamma
                            poi = obj.robot.right_arm_pos; %point of interest;
                            sample = datasample([0.1*randn-sig 0.1*randn+sig],1);
                            sample = datasample([0.1*randn-sig],1);
                            theta = atan2(poi(2)-obj.child.head_pos(2), poi(1)-obj.child.head_pos(1));
                            obj.child.head_angle = (1-beta)*obj.child.head_angle + beta*(theta+sample);
                        end
                        drawstate(obj);
                    end
                    %grab what can be grabed there...
                    obj.cube1.grabbed = false;
                    obj.cube2.grabbed = false;
                    obj.cube3.grabbed = false;
                    
                    if ismember(1,obj.map.layer3)&&(norm(obj.cube1.pos-obj.map.pos2)<0.1)
                        obj.cube1.grabbed = true;
                    elseif ismember(2,obj.map.layer3)&&(norm(obj.cube2.pos-obj.map.pos2)<0.1)
                        obj.cube2.grabbed = true;
                    elseif ismember(3,obj.map.layer3)&&(norm(obj.cube3.pos-obj.map.pos2)<0.1)
                        obj.cube3.grabbed = true;
                    end
                    %go to center position
                    obj.robot.head_angle_des = atan2(obj.map.pos3(2)-obj.robot.head_pos(2),obj.map.pos3(1)-obj.robot.head_pos(1));
                    while norm(obj.map.pos3 - obj.robot.right_arm_pos)>0.01
                        obj.robot.right_arm_pos = (1-p)*obj.robot.right_arm_pos + p*obj.map.pos3;
                        obj.robot.head_angle = (1-a*p)*obj.robot.head_angle + a*p*obj.robot.head_angle_des;
                        obj.robot.left_arm_pos = (1-p)*obj.robot.left_arm_pos + p*obj.robot.left_arm_pos_rest; %also move the other to rest..
                        if obj.cube1.grabbed
                            obj.cube1.pos = obj.robot.right_arm_pos;
                        elseif obj.cube2.grabbed
                            obj.cube2.pos = obj.robot.right_arm_pos;
                        elseif obj.cube3.grabbed
                            obj.cube3.pos = obj.robot.right_arm_pos;
                        end
                        
                        if rand>gamma
                            poi = obj.robot.right_arm_pos; %point of interest;
                            sample = datasample([0.1*randn-sig 0.1*randn+sig],1);
                            sample = datasample([0.1*randn-sig],1);
                            theta = atan2(poi(2)-obj.child.head_pos(2), poi(1)-obj.child.head_pos(1));
                            obj.child.head_angle = (1-beta)*obj.child.head_angle + beta*(theta+sample);
                        end
                        drawstate(obj);
                    end
                    if obj.cube1.grabbed
                        obj.cube1.grabbed = false;
                        obj.map.layer3(2) = obj.map.layer2(2);
                        obj.map.layer2(2) = obj.map.layer1(2);
                        obj.map.layer1(2) = 0;
                        obj.map.layer1(3) = obj.map.layer2(3);
                        obj.map.layer2(3) = obj.map.layer3(3);
                        obj.map.layer3(3) = 1;
                    elseif obj.cube2.grabbed
                        obj.cube2.grabbed = false;
                        obj.map.layer3(2) = obj.map.layer2(2);
                        obj.map.layer2(2) = obj.map.layer1(2);
                        obj.map.layer1(2) = 0;
                        obj.map.layer1(3) = obj.map.layer2(3);
                        obj.map.layer2(3) = obj.map.layer3(3);
                        obj.map.layer3(3) = 2;
                    elseif obj.cube3.grabbed
                        obj.cube3.grabbed = false;
                        obj.map.layer3(2) = obj.map.layer2(2);
                        obj.map.layer2(2) = obj.map.layer1(2);
                        obj.map.layer1(2) = 0;
                        obj.map.layer1(3) = obj.map.layer2(3);
                        obj.map.layer2(3) = obj.map.layer3(3);
                        obj.map.layer3(3) = 3;
                    end
                    %return to rest position
                    %action done here....! can use a flag
                    obj.robot.right_arm_pos_des = obj.robot.right_arm_pos_rest;
                    while norm(obj.robot.right_arm_pos - obj.robot.right_arm_pos_des)>0.01
                        obj.robot.right_arm_pos = (1-p)*obj.robot.right_arm_pos + p*obj.robot.right_arm_pos_des;
                        drawstate(obj);
                        if norm(obj.robot.right_arm_pos_rest - obj.robot.right_arm_pos)<1.5
                            %actiondone = true;
                            break;
                        end
                    end
                % ACTION 6 %%%%%%%%%%%%%%%%%
                case 5
                    % approach pos1...
                    obj.robot.head_angle_des = atan2(obj.map.pos3(2)-obj.robot.head_pos(2),obj.map.pos3(1)-obj.robot.head_pos(1));
                    while norm(obj.map.pos3 - obj.robot.right_arm_pos)>0.01
                        obj.robot.right_arm_pos = (1-p)*obj.robot.right_arm_pos + p*obj.map.pos3;
                        obj.robot.head_angle = (1-a*p)*obj.robot.head_angle + a*p*obj.robot.head_angle_des;
                        obj.robot.left_arm_pos = (1-p)*obj.robot.left_arm_pos + p*obj.robot.left_arm_pos_rest; %also move the other to rest..
                        
                        if rand>gamma
                            poi = obj.robot.right_arm_pos; %point of interest;
                            sample = datasample([0.1*randn-sig 0.1*randn+sig],1);
                            sample = datasample([0.1*randn-sig],1);
                            theta = atan2(poi(2)-obj.child.head_pos(2), poi(1)-obj.child.head_pos(1));
                            obj.child.head_angle = (1-beta)*obj.child.head_angle + beta*(theta+sample);
                        end
                        drawstate(obj);
                    end
                    %grab what can be grabed there...
                    obj.cube1.grabbed = false;
                    obj.cube2.grabbed = false;
                    obj.cube3.grabbed = false;
                    
                    if ismember(1,obj.map.layer3)&&(norm(obj.cube1.pos-obj.map.pos3)<0.1)
                        obj.cube1.grabbed = true;
                    elseif ismember(2,obj.map.layer3)&&(norm(obj.cube2.pos-obj.map.pos3)<0.1)
                        obj.cube2.grabbed = true;
                    elseif ismember(3,obj.map.layer3)&&(norm(obj.cube3.pos-obj.map.pos3)<0.1)
                        obj.cube3.grabbed = true;
                    end
                    %go to center position
                    obj.robot.head_angle_des = atan2(obj.map.pos1(2)-obj.robot.head_pos(2),obj.map.pos1(1)-obj.robot.head_pos(1));
                    while norm(obj.map.pos1 - obj.robot.right_arm_pos)>0.01
                        obj.robot.right_arm_pos = (1-p)*obj.robot.right_arm_pos + p*obj.map.pos1;
                        obj.robot.head_angle = (1-a*p)*obj.robot.head_angle + a*p*obj.robot.head_angle_des;
                        obj.robot.left_arm_pos = (1-p)*obj.robot.left_arm_pos + p*obj.robot.left_arm_pos_rest; %also move the other to rest..
                        if obj.cube1.grabbed
                            obj.cube1.pos = obj.robot.right_arm_pos;
                        elseif obj.cube2.grabbed
                            obj.cube2.pos = obj.robot.right_arm_pos;
                        elseif obj.cube3.grabbed
                            obj.cube3.pos = obj.robot.right_arm_pos;
                        end
                        if rand>gamma
                            poi = obj.robot.right_arm_pos; %point of interest;
                            sample = datasample([0.1*randn-sig 0.1*randn+sig],1);
                            sample = datasample([0.1*randn-sig],1);
                            theta = atan2(poi(2)-obj.child.head_pos(2), poi(1)-obj.child.head_pos(1));
                            obj.child.head_angle = (1-beta)*obj.child.head_angle + beta*(theta+sample);
                        end
                        drawstate(obj);
                    end
                    if obj.cube1.grabbed
                        obj.cube1.grabbed = false;
                        obj.map.layer3(3) = obj.map.layer2(3);
                        obj.map.layer2(3) = obj.map.layer1(3);
                        obj.map.layer1(3) = 0;
                        obj.map.layer1(1) = obj.map.layer2(1);
                        obj.map.layer2(1) = obj.map.layer3(1);
                        obj.map.layer3(1) = 1;
                    elseif obj.cube2.grabbed
                        obj.cube2.grabbed = false;
                        obj.map.layer3(3) = obj.map.layer2(3);
                        obj.map.layer2(3) = obj.map.layer1(3);
                        obj.map.layer1(3) = 0;
                        obj.map.layer1(1) = obj.map.layer2(1);
                        obj.map.layer2(1) = obj.map.layer3(1);
                        obj.map.layer3(1) = 2;
                    elseif obj.cube3.grabbed
                        obj.cube3.grabbed = false;
                        obj.map.layer3(3) = obj.map.layer2(3);
                        obj.map.layer2(3) = obj.map.layer1(3);
                        obj.map.layer1(3) = 0;
                        obj.map.layer1(1) = obj.map.layer2(1);
                        obj.map.layer2(1) = obj.map.layer3(1);
                        obj.map.layer3(1) = 3;
                    end
                    %return to rest position
                    %action done here....! can use a flag
                    obj.robot.right_arm_pos_des = obj.robot.right_arm_pos_rest;
                    while norm(obj.robot.right_arm_pos - obj.robot.right_arm_pos_des)>0.01
                        obj.robot.right_arm_pos = (1-p)*obj.robot.right_arm_pos + p*obj.robot.right_arm_pos_des;
                        drawstate(obj);
                        if norm(obj.robot.right_arm_pos_rest - obj.robot.right_arm_pos)<1.5
                            %actiondone = true;
                            break;
                        end
                    end
            end
        end
        
        
        %                 case 1
        %                     actions = [0 1 2];
        %                     idx = randperm(3);
        %                     pos = actions(idx(1));
        %                     if pos==0
        %                         obj.robot.right_arm_pos_des = obj.robot.pos0;
        %                     elseif pos==1
        %                         obj.robot.right_arm_pos_des = obj.robot.pos1;
        %                         obj.robot.head_angle_des = atan2(obj.robot.pos1(2)-obj.robot.head_pos(2),obj.robot.pos1(1)-obj.robot.head_pos(1));
        %                     elseif pos==2
        %                         obj.robot.right_arm_pos_des = obj.robot.pos2;
        %                         obj.robot.head_angle_des = atan2(obj.robot.pos2(2)-obj.robot.head_pos(2),obj.robot.pos2(1)-obj.robot.head_pos(1));
        %                     end
        %                     obj.robot.right_action_param = param;
        %                 case 2
        %                     obj.robot.right_arm_pos_des = obj.robot.right_arm_pos_rest;
        %                     obj.robot.right_action_param = param;
        %                     obj.robot.head_angle_des = pi/2;
        %                 case 3
        %                     cubes = randperm(4);
        %                     cube = cubes(1);
        %                     if cube == 1
        %                         obj.robot.right_arm_pos_des = obj.cube1.pos;
        %                         vdes = obj.cube1.pos - obj.robot.right_shoulder_pos;
        %                         Ldes = norm(obj.cube1.pos - obj.robot.right_shoulder_pos);
        %                         L = obj.robot.bicep_length+obj.robot.forearm_length + 0.9*obj.robot.fist_radius;
        %                         if Ldes > L
        %                             obj.robot.right_arm_pos_des = obj.robot.right_shoulder_pos + vdes*L/Ldes;
        %                         end
        %                         obj.robot.head_angle_des = atan2(obj.cube1.pos(2)-obj.robot.head_pos(2),obj.cube1.pos(1)-obj.robot.head_pos(1));
        %                     elseif cube == 2
        %                         obj.robot.right_arm_pos_des = obj.cube2.pos;
        %                         vdes = obj.cube2.pos - obj.robot.right_shoulder_pos;
        %                         Ldes = norm(obj.cube2.pos - obj.robot.right_shoulder_pos);
        %                         L = obj.robot.bicep_length+obj.robot.forearm_length + 0.9*obj.robot.fist_radius;
        %                         if Ldes > L
        %                             obj.robot.right_arm_pos_des = obj.robot.right_shoulder_pos + vdes*L/Ldes;
        %                         end
        %                         obj.robot.head_angle_des = atan2(obj.cube2.pos(2)-obj.robot.head_pos(2),obj.cube2.pos(1)-obj.robot.head_pos(1));
        %                     elseif cube == 3
        %                         obj.robot.right_arm_pos_des = obj.cube3.pos;
        %                         vdes = obj.cube3.pos - obj.robot.right_shoulder_pos;
        %                         Ldes = norm(obj.cube3.pos - obj.robot.right_shoulder_pos);
        %                         L = obj.robot.bicep_length+obj.robot.forearm_length + 0.9*obj.robot.fist_radius;
        %                         if Ldes > L
        %                             obj.robot.right_arm_pos_des = obj.robot.right_shoulder_pos + vdes*L/Ldes;
        %                         end
        %                         obj.robot.head_angle_des = atan2(obj.cube3.pos(2)-obj.robot.head_pos(2),obj.cube3.pos(1)-obj.robot.head_pos(1));
        %                     elseif cube == 4
        %                         obj.robot.right_arm_pos_des = obj.cube4.pos;
        %                         vdes = obj.cube4.pos - obj.robot.right_shoulder_pos;
        %                         Ldes = norm(obj.cube4.pos - obj.robot.right_shoulder_pos);
        %                         L = obj.robot.bicep_length+obj.robot.forearm_length + 0.9*obj.robot.fist_radius;
        %                         if Ldes > L
        %                             obj.robot.right_arm_pos_des = obj.robot.right_shoulder_pos + vdes*L/Ldes;
        %                         end
        %                         obj.robot.head_angle_des = atan2(obj.cube4.pos(2)-obj.robot.head_pos(2),obj.cube4.pos(1)-obj.robot.head_pos(1));
        %                     end
        %                         obj.robot.left_action_param = param;
        %                 case 4
        %                     actions = [0 3 4];
        %                     idx = randperm(3);
        %                     pos = actions(idx(1));
        %                     if pos==0
        %                         obj.robot.left_arm_pos_des = obj.robot.pos0;
        %                     elseif pos==3
        %                         obj.robot.left_arm_pos_des = obj.robot.pos3;
        %                         obj.robot.head_angle_des = atan2(obj.robot.pos3(2)-obj.robot.head_pos(2),obj.robot.pos3(1)-obj.robot.head_pos(1));
        %                     elseif pos==4
        %                         obj.robot.left_arm_pos_des = obj.robot.pos4;
        %                         obj.robot.head_angle_des = atan2(obj.robot.pos4(2)-obj.robot.head_pos(2),obj.robot.pos4(1)-obj.robot.head_pos(1));
        %                     end
        %                     obj.robot.right_action_param = param;
        %                 case 5
        %                     obj.robot.left_arm_pos_des = obj.robot.left_arm_pos_rest;
        %                     obj.robot.left_action_param = param;
        %                     obj.robot.head_angle_des = pi/2;
        %                 case 6
        %                     cubes = randperm(4);
        %                     cube = cubes(1);
        %                     if cube == 1
        %                         obj.robot.left_arm_pos_des = obj.cube1.pos;
        %                         vdes = obj.cube1.pos - obj.robot.left_shoulder_pos;
        %                         Ldes = norm(obj.cube1.pos - obj.robot.left_shoulder_pos);
        %                         L = obj.robot.bicep_length+obj.robot.forearm_length + 0.9*obj.robot.fist_radius;
        %                         if Ldes > L
        %                             obj.robot.left_arm_pos_des = obj.robot.left_shoulder_pos + vdes*L/Ldes;
        %                         end
        %                         obj.robot.head_angle_des = atan2(obj.cube1.pos(2)-obj.robot.head_pos(2),obj.cube1.pos(1)-obj.robot.head_pos(1));
        %                     elseif cube == 2
        %                         obj.robot.left_arm_pos_des = obj.cube2.pos;
        %                         vdes = obj.cube2.pos - obj.robot.left_shoulder_pos;
        %                         Ldes = norm(obj.cube2.pos - obj.robot.left_shoulder_pos);
        %                         L = obj.robot.bicep_length+obj.robot.forearm_length + 0.9*obj.robot.fist_radius;
        %                         if Ldes > L
        %                             obj.robot.left_arm_pos_des = obj.robot.left_shoulder_pos + vdes*L/Ldes;
        %                         end
        %                         obj.robot.head_angle_des = atan2(obj.cube2.pos(2)-obj.robot.head_pos(2),obj.cube2.pos(1)-obj.robot.head_pos(1));
        %                     elseif cube == 3
        %                         obj.robot.left_arm_pos_des = obj.cube3.pos;
        %                         vdes = obj.cube3.pos - obj.robot.left_shoulder_pos;
        %                         Ldes = norm(obj.cube3.pos - obj.robot.left_shoulder_pos);
        %                         L = obj.robot.bicep_length+obj.robot.forearm_length + 0.9*obj.robot.fist_radius;
        %                         if Ldes > L
        %                             obj.robot.left_arm_pos_des = obj.robot.left_shoulder_pos + vdes*L/Ldes;
        %                         end
        %                         obj.robot.head_angle_des = atan2(obj.cube3.pos(2)-obj.robot.head_pos(2),obj.cube3.pos(1)-obj.robot.head_pos(1));
        %                     elseif cube == 4
        %                         obj.robot.left_arm_pos_des = obj.cube4.pos;
        %                         vdes = obj.cube4.pos - obj.robot.left_shoulder_pos;
        %                         Ldes = norm(obj.cube4.pos - obj.robot.left_shoulder_pos);
        %                         L = obj.robot.bicep_length+obj.robot.forearm_length + 0.9*obj.robot.fist_radius;
        %                         if Ldes > L
        %                             obj.robot.left_arm_pos_des = obj.robot.left_shoulder_pos + vdes*L/Ldes;
        %                         end
        %                         obj.robot.head_angle_des = atan2(obj.cube4.pos(2)-obj.robot.head_pos(2),obj.cube4.pos(1)-obj.robot.head_pos(1));
        %                     end
        %                        obj.robot.left_action_param = param;
        
        
        
        function obj = step(obj)
            obj.time = obj.time+1;
            obj.robot.head_angle = (1-obj.robot.head_action_param)*obj.robot.head_angle + obj.robot.head_action_param*obj.robot.head_angle_des;
            obj.robot.right_arm_pos = (1-obj.robot.right_action_param)*obj.robot.right_arm_pos + obj.robot.right_action_param*obj.robot.right_arm_pos_des;
            obj.robot.left_arm_pos = (1-obj.robot.left_action_param)*obj.robot.left_arm_pos + obj.robot.left_action_param*obj.robot.left_arm_pos_des;
            
            if norm(obj.robot.right_arm_pos-obj.cube1.pos)<=0.01
                obj.cube1.grasped_right = 2*rand>0.5;
            elseif norm(obj.robot.right_arm_pos - obj.cube2.pos)<=0.01
                obj.cube2.grasped_right = 2*rand>0.5;
            elseif norm(obj.robot.right_arm_pos - obj.cube3.pos)<=0.01
                obj.cube3.grasped_right = round(rand);
            elseif norm(obj.robot.right_arm_pos - obj.cube4.pos)<=0.01
                obj.cube4.grasped_right = round(rand);
            end
            if obj.cube1.grasped_right==1
                obj.cube1.pos = obj.robot.right_arm_pos;
            end
            if obj.cube2.grasped_right==1
                obj.cube2.pos = obj.robot.right_arm_pos;
            end
            if obj.cube3.grasped_right==1
                obj.cube3.pos = obj.robot.right_arm_pos;
            end
            if obj.cube4.grasped_right==1
                obj.cube4.pos = obj.robot.right_arm_pos;
            end
            
            if norm(obj.robot.left_arm_pos-obj.cube1.pos)<=0.01 && obj.cube1.grasped_right==0
                obj.cube1.grasped_left = round(rand);
            elseif norm(obj.robot.left_arm_pos - obj.cube2.pos)<=0.01 && obj.cube2.grasped_right==0
                obj.cube2.grasped_left = round(rand);
            elseif norm(obj.robot.left_arm_pos - obj.cube3.pos)<=0.01 && obj.cube3.grasped_right==0
                obj.cube3.grasped_left = 2*rand>0.5;
            elseif norm(obj.robot.left_arm_pos - obj.cube4.pos)<=0.01 && obj.cube4.grasped_right==0
                obj.cube4.grasped_left = 2*rand>0.5;
            end
            
            if obj.cube1.grasped_left==1
                obj.cube1.pos = obj.robot.left_arm_pos;
            end
            if obj.cube2.grasped_left==1
                obj.cube2.pos = obj.robot.left_arm_pos;
            end
            if obj.cube3.grasped_left==1
                obj.cube3.pos = obj.robot.left_arm_pos;
            end
            if obj.cube4.grasped_left==1
                obj.cube4.pos = obj.robot.left_arm_pos;
            end
            
            if mod(obj.time, 10) == 1
                %p = [obj.cube1.pos; obj.cube2.pos; obj.cube3.pos; obj.cube4.pos; obj.robot.pos0];
                p = [obj.robot.right_arm_pos; obj.robot.left_arm_pos; obj.robot.pos0];
                idx = randperm(3);
                p = p(idx(1),:);
                obj.child.head_action_param = rand;
                obj.child.head_angle_des = atan2(p(2)-obj.child.head_pos(2), p(1)-obj.child.head_pos(1));
            end
            obj.child.head_angle = obj.child.head_action_param*obj.child.head_angle + (1-obj.child.head_action_param)*obj.child.head_angle_des;
            
            
        end
        
    end
end
