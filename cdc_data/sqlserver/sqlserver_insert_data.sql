Declare @Id int
Set @Id = 100001

While @Id <= 200000
Begin 
   Insert Into striim_schema.employee values (@Id, 'John Doe',1)
   Print @Id
   Set @Id = @Id + 1
End
