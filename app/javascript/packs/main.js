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

$('#assign-task').on('click',function(){
  let _task_name=$('#task-name').val()
  let _task_category=$('#task-category').find(":selected").val();
  let _task_date=$('#task-date').val()
  let _task_time=$('#task-time').val()

  let _assign_to=$('#assign-to').find(":selected").val()
  let _task_priority=$('#task-priority').find(":selected").val()
  let _notification_interval=$('input[name=Interval]:checked').val()
  let _task_attachment=$('#task-attachment').val()

  var fd = new FormData();
  var files = $('#task-attachment')[0].files[0];
  fd.append('file',files);
  let _sub_task={}
  var listItems = $("#sub-task-list li");
  listItems.each(function(idx, li) {
      var product = $(li).text();
      _sub_task[idx]=product;
      
  });

  const data={
    task_name:_task_name,
    task_category:_task_category,
    task_date:_task_date,
    task_time:_task_time,
    assign_to:_assign_to,
    sub_task:_sub_task,
    task_importance:_task_priority,
    notification_interval:_notification_interval
  }

  console.log(data)


  $.ajax({
    url:'/dashboard/assigntask/tasks',
    method:'POST',
    data:{task_data:data ,authenticity_token: $('meta[name="csrf-token"]').attr('content')},
    success:function(data){
      // show_toast("Admin created successfully")
    },
    error:function(err){

    }
  })


})


$('#add-subtask').on('click', function(){

  let sub_task=$('#sub-task-input').val();
  $('#sub-task-list').append(`<li class="list-group-item d-flex justify-content-between align-items-start">${sub_task} <a class="btn btn-danger"><i class="fa fa-trash"></i></a></li>`);
  $('#sub-task-input').val('')
})

$(document).on('change','.task-status-change', function(){
  let data={
    id: $(this)[0].id,
    status: $(this).val()
  }
  $.ajax({
    url:'/tasks/change_task_status',
    method:'POST',
    data:{task_data:data ,authenticity_token: $('meta[name="csrf-token"]').attr('content')},
    success:function(data){
      
    },
    error:function(err){

    }
  })
})
$(document).on('change','.subtask-status-change', function(){
  let data={
    id: $(this)[0].id,
    status: $(this).val()
  }
  $.ajax({
    url:'/tasks/change_subtask_status',
    method:'POST',
    data:{subtask_data:data ,authenticity_token: $('meta[name="csrf-token"]').attr('content')},
    success:function(data){
    },
    error:function(err){
    }
  })
})


$(document).on('change','.day-filter', function(){

  
  // console.log($(this).attr('data'))
  check_filter($(this).attr('data'));
    
})

$(document).on('change','.priority-filter', function(){
  
  // console.log($(this).attr('data'))
  check_filter($(this).attr('data'));
    
})

function check_filter(status){
  let _day= $(`#${status}-day-filter`).val()
  let _priority= $(`#${status}-priority-filter`).val()

  let data={
    identify:status
  }

  if(_day=="1"){

    if(_priority!="3"){
      data['priority']=_priority
    }
  }
  else{
    
    data['day']=_day
    if(_priority!="3"){
      data['priority']=_priority
    }
  }

  console.log(data)


  $.ajax({
    url:'/tasks/apply_filters',
    method:'GET',
    data:{filters:data ,authenticity_token: $('meta[name="csrf-token"]').attr('content')},
    success:function(data){
    },
    error:function(err){
    }
  })
  
}