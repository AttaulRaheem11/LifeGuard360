import re
from marshmallow import Schema, fields, validate, validates, ValidationError


def validate_phone(value):
    # E.164-compatible or standard 10-15 digit phone validation
    pattern = r'^\+?[0-9]{7,15}$'
    if not re.match(pattern, value.strip()):
        raise ValidationError("Invalid phone number format. Must contain 7 to 15 digits, optional leading '+'.")


class RegisterSchema(Schema):
    full_name = fields.String(required=True, validate=validate.Length(min=2, max=120))
    email = fields.Email(required=True, validate=validate.Length(max=191))
    phone = fields.String(required=True, validate=validate_phone)
    password = fields.String(required=True, validate=validate.Length(min=8, max=128))
    blood_group = fields.String(allow_none=True, validate=validate.OneOf(
        ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-', None, '']
    ))
    default_emergency_number = fields.String(allow_none=True, validate=validate.Length(min=2, max=20))


class LoginSchema(Schema):
    email_or_phone = fields.String(required=True, validate=validate.Length(min=3, max=191))
    password = fields.String(required=True, validate=validate.Length(min=1, max=128))


class ProfileUpdateSchema(Schema):
    full_name = fields.String(allow_none=True, validate=validate.Length(min=2, max=120))
    blood_group = fields.String(allow_none=True, validate=validate.OneOf(
        ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-', None, '']
    ))
    allergies = fields.String(allow_none=True)
    medical_notes = fields.String(allow_none=True)
    emergency_notes = fields.String(allow_none=True)
    default_emergency_number = fields.String(allow_none=True, validate=validate.Length(min=2, max=20))
    checkin_grace_period_minutes = fields.Integer(allow_none=True, validate=validate.Range(min=1, max=60))
    pre_alert_countdown_seconds = fields.Integer(allow_none=True, validate=validate.Range(min=10, max=45))
