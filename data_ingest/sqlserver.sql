Declare @Id int
Set @Id = 1

While @Id <= 100000
Begin 
   Insert Into striim_schema.employee values (@Id, 'John Doe',1)
   Print @Id
   Set @Id = @Id + 1
End
