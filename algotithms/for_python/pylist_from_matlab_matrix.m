function [pylist] = pylist_from_matlab_matrix(matrix)
       
%     pylist = mat2cell(matrix,matrix(1,:));
      matrix = im2uint8(matrix)
      cell_matrix = num2cell(matrix);
      pylist = cell(1,size(matrix,1));

      for i= 1:size(matrix,1)
          pylist{i} = cell_matrix(1,:);
      end
end

