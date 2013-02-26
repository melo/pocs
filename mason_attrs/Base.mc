<%class>
has 'title';
</%class>

<%augment wrap>
%
% $.Defer {{
%
<& 'title.mi' &>
%
% }}
%
<% inner() %>
</%augment>
