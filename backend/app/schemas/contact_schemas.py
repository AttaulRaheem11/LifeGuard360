from marshmallow import Schema, fields, validate
from app.schemas.auth_schemas import validate_phone


class ContactCreateSchema(Schema):
    name = fields.String(required=True, validate=validate.Length(min=2, max=120))
    phone = fields.String(required=True, validate=validate_phone)
    email = fields.Email(allow_none=True, validate=validate.Length(max=191))
    relationship = fields.String(required=False, load_default='Family', validate=validate.Length(max=50))
    priority_tier = fields.Integer(required=False, load_default=1, validate=validate.OneOf([1, 2, 3]))
    notify_sms = fields.Boolean(required=False, load_default=True)
    notify_push = fields.Boolean(required=False, load_default=True)
    notify_call = fields.Boolean(required=False, load_default=False)


class ContactUpdateSchema(Schema):
    name = fields.String(allow_none=True, validate=validate.Length(min=2, max=120))
    phone = fields.String(allow_none=True, validate=validate_phone)
    email = fields.Email(allow_none=True, validate=validate.Length(max=191))
    relationship = fields.String(allow_none=True, validate=validate.Length(max=50))
    priority_tier = fields.Integer(allow_none=True, validate=validate.OneOf([1, 2, 3]))
    notify_sms = fields.Boolean(allow_none=True)
    notify_push = fields.Boolean(allow_none=True)
    notify_call = fields.Boolean(allow_none=True)
