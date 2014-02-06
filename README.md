### Model of an instructor's private homework repo

- hw-tests/
    - .travis.yml : CI that validates homework runs against AutoGraders project.
    - features/ : tests that are run automatically by travis
    - ruby-intro/ : sample homework
        - autograder : graders in the form of tests and supporting files
        - public : skeleton and Readme displayed to student
        - solutions : used for validating graders
