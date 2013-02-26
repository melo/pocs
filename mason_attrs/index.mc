<%init>
  $self->title('my title');
</%init>

index.mc component is <% $self %>.
index.mc title was set to '<% $self->title // '<undef>' %>'.
