# Challenge

This is a project that consists of 5 companies and 35 users belongs to a company based on two json files.

Based on the email status of the user the companies decided whether to send an email or not regardless of the company's status based on the criteria of the challenge creater

I added three test files in the spec file to verify the input and output of the classes

I put challenge.rb inside file lib


### Setup tools:
- Ruby (3.2.0)
- Rspec (6.0.0)


1. Clone the repository
```bash
git clone https://github.com/masoud-arabi/challenge.git
```

2. Install bundle
```bash
bundle install
```

3.To run the code
```bash
ruby lib/challenge.rb
```

4.Run tests
```bash
rspec spec/controller_spec.rb
rspec spec/company_spec.rb
rspec spec/user_spec.rb
```