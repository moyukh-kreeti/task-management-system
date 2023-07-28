# Setup for the Application

This README would normally document whatever steps are necessary to get the
application up and running.

The steps need to be followed

The versions required are

* Ruby version 3.2.1
* Rails version 6.1.7.3
* PostgresSQL version 14.8
* node version v16.20.0
* yarn version 1.22.19
* elasticsearch version 7.17.11
* redis-server version 6.0.16
  
The correct versions of the above-mentioned software should be installed on your local system for running the application.

#### After all the softwere are installed the following steps to be performed 

#### 1. To install all the dependency and gem run the following comand
``` bash
bundle install && yarn install
```
#### 2. To setup the database (create database, migrate and seed the databse) run the following comand

```ruby
rails db:setup
```

#### 3. Make sure that the elastic-search is running on the system at ```localhost:9200```

#### 4. Then run the rails server by the following comand

```ruby
rails s
```

#### 5. Then run to run the cron job for scheduling the notification run the following comand

```bash
whenever --update-crontab
```

#### 6. Then, As mentioneed in the requirement to open the application one user should be added by the admin first then he/she can login to the system by the google account added by the admin. So to create a admin user firstly visit the below link

[To add the first admin user](http://localhost:3000/superuser/add/adminuser)

#### 5. Then Log in to the system through that email address added at the above link

#### Then admin can add more user to login to the system by adding user to admin panel


