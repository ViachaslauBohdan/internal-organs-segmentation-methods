classes = {'left kidney', 'right kidney','spine','liver', 'bowel loops', 'muscles', 'stomach'};

ref_props = {};

obj.name = 'left kidney';
obj.centroidX = 161;
obj.centroidY = 335;
obj.axis_ratio = 1.1;
obj.area = 20;
ref_props{1,1} = obj;

obj.name = 'right kidney';
obj.centroidX = 338;
obj.centroidY = 319;
obj.axis_ratio = 1.1;
obj.area = 20;
ref_props{1,2} = obj;

obj.name = 'spine';
obj.centroidX = 258;
obj.centroidY = 330;
obj.axis_ratio = 1.1;
obj.area = 10;
ref_props{1,3} = obj;

obj.name = 'liver';
obj.centroidX = 145;
obj.centroidY = 210;
obj.axis_ratio = 1.4;
obj.area = 100;
ref_props{1,4} = obj;

obj.name = 'muscles';
obj.centroidX = 244;
obj.centroidY = 379;
obj.axis_ratio = 2;
obj.area = 30;
ref_props{1,5} = obj;

obj.name = 'stomach';
obj.centroidX = 354;
obj.centroidY = 210;
obj.axis_ratio = 1.4;
obj.area = 50;
ref_props{1,6} = obj;

function detect_organ(props)
end
