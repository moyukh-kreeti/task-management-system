$('#change_pic').click(function(){
  console.log('clicked')
  $('#take_pic').trigger('click')
  $('#take_pic').on('change',function(e){
    if(e.target.files.length>0){
      $('#submit_btn').trigger('click');
    }
    
  })
})

$('#add-user').click(function(){
  $('#exampleModal').modal('show')
})
$('#change-employee-details').click(function(){
  $('#exampleModal2').modal('show')
})

$('#add-user-to-db').click(function(){
  let _fname=$('#input-fname').val()
  let _lname=$('#input-lname').val()
  let _email=$('#input-email').val()
  let _roles=$('#input-roles').val()
  
  const user={
    fname:_fname,
    lname:_lname,
    email:_email,
    roles:Number(_roles)
  }

  add_user(user)

})


function add_user(user){
  $.ajax({
    url: '/admin/addUser',
    method: 'POST',
    data: { info: user, authenticity_token: $('meta[name="csrf-token"]').attr('content') },
    success: function(response) {
      show_toast("User added successfully")
      
    },
    error: function(xhr, status, error) {
  
    }
    });
  
}

function show_toast(msg){
  var toastElList = [].slice.call(document.querySelectorAll('.toast'))
  var toastList = toastElList.map(function(toastEl) {
    $(toastEl).children()[1].innerHTML=msg
    return new bootstrap.Toast(toastEl)
  })
  toastList.forEach(toast => toast.show())
}

$('.make-hr').on('click',function(){

  makeHR($(this).val())
  
})

$('.make-admin').on('click',function(){

  makeAdmin($(this).val())

})

$('#add-task-categories').on('click',function(){
  $('#addTaskCategoriesModal').modal('show')
})

$('#add-task-caregory').on('click',function(){
  category=$('#input-category').val()
  $('#input-category').val('')
  addCategory(category)
  

})

$('.del-task-category').on('click',function(){
  console.log($(this).attr('value'))
  removeCategory($(this).attr('value'))
})

function makeAdmin(_id){

  $.ajax({

    url:'/admin/makeAdmin',
    method:'POST',
    data:{id: _id,authenticity_token: $('meta[name="csrf-token"]').attr('content')},
    success:function(data){
      show_toast("Admin created successfully")
    },
    error:function(err){

    }

  })

}

function makeHR(_id){


  $.ajax({

    url:'/admin/makeHr',
    method:'POST',
    data:{id: _id,authenticity_token: $('meta[name="csrf-token"]').attr('content')},
    success:function(data){
      show_toast("HRD created successfully")
    },
    error:function(err){
      
    }

  })
}

function addCategory(category){
  $.ajax({

    url:'/admin/addTaskCategories',
    method:'POST',
    data:{data: category,authenticity_token: $('meta[name="csrf-token"]').attr('content')},
    success:function(data){
      show_toast("Category created successfully")
    },
    error:function(err){
      
    }

  })
}

function removeCategory(_id){

  $.ajax({
    url:'/admin/removeTaskCategories',
    method:'DELETE',
    data:{id: _id,authenticity_token: $('meta[name="csrf-token"]').attr('content')},
    success:function(data){
      show_toast("Category Deleted successfully")
    },
    error:function(err){
      
    }

  })
}


$('#assign-task-to-user').on('click', function(){

  $('#task-add-modal').modal('show');

})

