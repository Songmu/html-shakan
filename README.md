[![Build Status](https://travis-ci.org/Songmu/html-shakan.png?branch=master)](https://travis-ci.org/Songmu/html-shakan) [![Coverage Status](https://coveralls.io/repos/Songmu/html-shakan/badge.png?branch=master)](https://coveralls.io/r/Songmu/html-shakan?branch=master)
# NAME

HTML::Shakan - Form HTML generator/validator

# SYNOPSIS

    use HTML::Shakan;

    sub form {
        my $req = shift;
        HTML::Shakan->new(
            fields => [ @_ ],
            request => $req,
            model => 'DataModel',
        );
    }
    sub edit {
        my $req = shift;
        my $row = $model->get('user' => $req->param('id'));
        my $form = form(
            $req => (
                TextField(name => 'name', label => 'Your name', filter => [qw/WhiteSpace/]),
                EmailField(name => 'email', label => 'Your email'),
            ),
        );
        if ($req->submitted_and_valid) {
            $form->model->update($row);
            redirect('edit_thanks');
        } else {
            $form->model->fill($row);
            render(form => $form);
        }
    }
    sub add {
        my $req = shift;
        my $form = form(
            $req => (
                TextField(name => 'name', label => 'Your name'),
                EmailField(name => 'email', label => 'Your email'),
            )
        );
        if ($req->submitted_and_valid) {
            $form->model->insert($model => 'user');
            redirect('edit_thanks');
        }
        render(form => $form);
    }

    # in your template
    <? if ($form->has_error) { ?><div class="error"><?= $form->error_message() ?></div><? } ?>
    <form method="post" action="add">
    <?= $form->render() ?>
    <p><input type="submit" value="add" /></p>
    </form>

# DESCRIPTION

HTML::Shakan is yet another form generator.

THIS IS BETA.API WILL CHANGE.

# ATTRIBUTES

- `custom_validation`

        form 'login' => (
            fields => [
                TextField(name => 'login_id'),
                PasswordField(name => 'login_pw'),
            ],
            custom_validation => sub {
                my $form = shift;
                if ($form->is_valid && !MyDB->retrieve($form->param('login_id'), $form->param('login_pw'))) {
                    $form->set_error('login' => 'failed');
                }
            }
        );

    You can set custom validation callback, validates the field set in the form. For example, this is useful for login form.

- `submitted`

    Returns true if the form has been submitted.

    This attribute will return true if a value for any known field name was submitted.

- `has_error`

    Return true if request has an error.

- `submitted_and_valid`

    Shorthand for `$form->submitted && !$form->has_error`

- `params`

    Returns form parameters. It is [Hash::MultiValue](http://search.cpan.org/perldoc?Hash::MultiValue) object.

- `param($key:Str)`

    Retrive the value of the key from parameters. It's behaviour is similar to traditional request objects. (ex. CGI, Plack::Request)
    That is, it returns single scalar at scalar context and returns array at array context.

# benchmarking

form generation

                     Rate         formfu         shakan shakan_declare
    formfu         1057/s             --           -77%           -84%
    shakan         4695/s           344%             --           -31%
    shakan_declare 6757/s           539%            44%             --

# What's shakan

Shakan is 左官 in Japanese.

If you want to know about shakan, please see [http://www.konuma-sakan.com/index2.html](http://www.konuma-sakan.com/index2.html)

左官 should pronounce 'sakan', formally. but, edokko pronounce 左官 as shakan.

# METHODS

- `my $html = $shakan->render(); :Str`

    Render form.

- `$shakan->render_field($name); :Str`

    Render partial form named `<$name`\>.

# AUTHOR

Tokuhiro Matsuno <tokuhirom  @ gmail.com>

# SEE ALSO

[HTML::FormFu](http://search.cpan.org/perldoc?HTML::FormFu)

ToscaWidgets

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
