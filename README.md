# Little Esty Shop Bulk Discounts

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]

Link to Live Application: [Little Esty Shop Bulk Discounts](https://shielded-basin-82582.herokuapp.com/)

## Table of Contents

- [Overview](#overview)
- [Learning Goals](#learning-goals)
- [Tools Used](#tools-used)
- [Database Schema](#database-schema)
- [Getting Started](#getting-started)
- [Contributors](#contributors)

## Overview

[Little Esty Shop Bulk Discounts](https://github.com/Scott-Borecki/little_esty_shop_bulk_discounts) is a 7-day, final solo project during Mod 2 of 4 for Turing School's Back End Engineering Program.  This project builds off the Mod 2 group project, [Little Esty Shop](https://github.com/turingschool-examples/little-esty-shop).

Little Esty Shop is an e-commerce platform where Merchants and Admins can manage inventory and fulfill customer invoices.  The Bulk Discounts extension consisted of adding functionality for merchants to create bulk discounts for their items.  A "bulk discount" is a discount based on the quantity of items the customer is buying (e.g. 20% off orders of 10 or more items).

## Learning Goals

Learning goals and areas of focus consisted of:

- Practice designing a normalized database schema, defining model relationships, and writing migrations to create tables and relationships between tables.
- Use MVC to organize code effectively, limiting the amount of logic included in views and controllers.
- Implement CRUD functionality for a resource using forms, buttons, and links.
- Use advanced routing techniques, including namespacing, to organize and group like functionality together.
- Use built-in ActiveRecord methods to join multiple tables of data, make calculations, group data based on one or more attributes, and perform complex database queries.
- Write model tests that fully cover the data logic of the application.
- Write feature tests that fully cover the functionality of the application.
- Practice consuming public APIs while utilizing POROs as a way to apply OOP principles to organize code.

Little Esty Shop project requirements: [link](https://github.com/turingschool-examples/little-esty-shop)<br />
Bulk Discounts project requirements: [link](https://backend.turing.edu/module2/projects/bulk_discounts)

## Tools Used

### Framework
<p>
  <img src="https://img.shields.io/badge/ruby%20on%20rails-b81818.svg?&style=for-the-badge&logo=rubyonrails&logoColor=white" />
</p>

### Languages
<p>
  <img src="https://img.shields.io/badge/ruby-CC342D.svg?&style=for-the-badge&logo=ruby&logoColor=white" />
  <img src="https://img.shields.io/badge/html5-E34F26.svg?&style=for-the-badge&logo=html5&logoColor=white" />
  <img src="https://img.shields.io/badge/css3-1572B6.svg?&style=for-the-badge&logo=css3&logoColor=white" />
  <img src="https://img.shields.io/badge/SQL-4169E1.svg?style=for-the-badge&logo=SQL&logoColor=white" />
  <img src="https://img.shields.io/badge/ActiveRecord-CC0000.svg?&style=for-the-badge&logo=rubyonrails&logoColor=white" />
</p>


### Tools
<p>
  <img src="https://img.shields.io/badge/Atom-66595C.svg?&style=for-the-badge&logo=atom&logoColor=white" />  
  <img src="https://img.shields.io/badge/git-F05032.svg?&style=for-the-badge&logo=git&logoColor=white" />
  <img src="https://img.shields.io/badge/GitHub-181717.svg?&style=for-the-badge&logo=github&logoColor=white" />
  <img src="https://img.shields.io/badge/Heroku-430098.svg?&style=for-the-badge&logo=heroku&logoColor=white" />
  <img src="https://img.shields.io/badge/PostgreSQL-4169E1.svg?&style=for-the-badge&logo=postgresql&logoColor=white" /> <br />

  <img src="https://img.shields.io/badge/postico-4169E1.svg?&style=for-the-badge&logo=Postico&logoColor=white" />  
</p>

#### Gems
<p>
  <img src="https://img.shields.io/badge/bootstrap-7952B3.svg?&style=for-the-badge&logo=bootstrap&logoColor=white" />
  <img src="https://img.shields.io/badge/capybara-E9573F.svg?&style=for-the-badge&logo=rubygems&logoColor=white" />
  <img src="https://img.shields.io/badge/factorybot-E9573F.svg?&style=for-the-badge&logo=rubygems&logoColor=white" />
  <img src="https://img.shields.io/badge/faker-E9573F.svg?&style=for-the-badge&logo=rubygems&logoColor=white" />
  <img src="https://img.shields.io/badge/faraday-E9573F.svg?&style=for-the-badge&logo=rubygems&logoColor=white" /> <br />

  <img src="https://img.shields.io/badge/launchy-E9573F.svg?&style=for-the-badge&logo=rubygems&logoColor=white" />  
  <img src="https://img.shields.io/badge/orderly-E9573F.svg?&style=for-the-badge&logo=rubygems&logoColor=white" />  
  <img src="https://img.shields.io/badge/pry-E9573F.svg?&style=for-the-badge&logo=rubygems&logoColor=white" />  
  <img src="https://img.shields.io/badge/rspec-E9573F.svg?&style=for-the-badge&logo=rubygems&logoColor=white" />
  <img src="https://img.shields.io/badge/Sass-CC6699.svg?&style=for-the-badge&logo=sass&logoColor=white" /> <br />

  <img src="https://img.shields.io/badge/shoulda--matchers-E9573F.svg?&style=for-the-badge&logo=rubygems&logoColor=white" />
  <img src="https://img.shields.io/badge/simplecov-E9573F.svg?&style=for-the-badge&logo=rubygems&logoColor=white" />  
  <img src="https://img.shields.io/badge/vcr-E9573F.svg?&style=for-the-badge&logo=rubygems&logoColor=white" />  
  <img src="https://img.shields.io/badge/webmock-E9573F.svg?&style=for-the-badge&logo=rubygems&logoColor=white" />  
</p>

### Processes
<p>
  <img src="https://img.shields.io/badge/OOP-b81818.svg?&style=for-the-badge&logo=OOP&logoColor=white" />
  <img src="https://img.shields.io/badge/TDD-b87818.svg?&style=for-the-badge&logo=TDD&logoColor=white" />
  <img src="https://img.shields.io/badge/MVC-b8b018.svg?&style=for-the-badge&logo=MVC&logoColor=white" />
  <img src="https://img.shields.io/badge/REST-33b818.svg?&style=for-the-badge&logo=REST&logoColor=white" />  
</p>

## Database Schema

![Database Schema](app/assets/images/database_schema.png)

## Contributors

👤  **Scott Borecki**
- Github: [Scott-Borecki](https://github.com/Scott-Borecki)
- LinkedIn: [Scott Borecki](https://www.linkedin.com/in/scott-borecki/)

<!-- MARKDOWN LINKS & IMAGES -->

[contributors-shield]: https://img.shields.io/github/contributors/Scott-Borecki/little_esty_shop_bulk_discounts.svg?style=flat-square
[contributors-url]: https://github.com/Scott-Borecki/little_esty_shop_bulk_discounts/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/Scott-Borecki/little_esty_shop_bulk_discounts.svg?style=flat-square
[forks-url]: https://github.com/Scott-Borecki/little_esty_shop_bulk_discounts/network/members
[stars-shield]: https://img.shields.io/github/stars/Scott-Borecki/little_esty_shop_bulk_discounts.svg?style=flat-square
[stars-url]: https://github.com/Scott-Borecki/little_esty_shop_bulk_discounts/stargazers
[issues-shield]: https://img.shields.io/github/issues/Scott-Borecki/little_esty_shop_bulk_discounts.svg?style=flat-square
[issues-url]: https://github.com/Scott-Borecki/little_esty_shop_bulk_discounts/issues
