from marshmallow import Schema, fields, validate


class SOSTriggerSchema(Schema):
    client_incident_uuid = fields.String(allow_none=True, validate=validate.Length(min=36, max=36))
    trigger_source = fields.String(
        required=False,
        load_default='MANUAL',
        validate=validate.OneOf(['MANUAL', 'AUTOMATED_RISK', 'OVERDUE_CHECKIN', 'SEVERE_FALL'])
    )
    risk_score_at_trigger = fields.Float(required=False, load_default=0.0, validate=validate.Range(min=0.0, max=100.0))
    latitude = fields.Float(allow_none=True, validate=validate.Range(min=-90.0, max=90.0))
    longitude = fields.Float(allow_none=True, validate=validate.Range(min=-180.0, max=180.0))
    accuracy = fields.Float(allow_none=True, validate=validate.Range(min=0.0))
    triggered_at = fields.DateTime(allow_none=True)


class SOSSyncItemSchema(Schema):
    client_incident_uuid = fields.String(required=True, validate=validate.Length(min=36, max=36))
    trigger_source = fields.String(
        required=False,
        load_default='MANUAL',
        validate=validate.OneOf(['MANUAL', 'AUTOMATED_RISK', 'OVERDUE_CHECKIN', 'SEVERE_FALL'])
    )
    risk_score_at_trigger = fields.Float(required=False, load_default=0.0, validate=validate.Range(min=0.0, max=100.0))
    latitude = fields.Float(allow_none=True, validate=validate.Range(min=-90.0, max=90.0))
    longitude = fields.Float(allow_none=True, validate=validate.Range(min=-180.0, max=180.0))
    accuracy = fields.Float(allow_none=True, validate=validate.Range(min=0.0))
    triggered_at = fields.DateTime(required=True)


class SOSSyncSchema(Schema):
    incidents = fields.List(fields.Nested(SOSSyncItemSchema), required=True, validate=validate.Length(min=1))


class SOSCancelSchema(Schema):
    incident_id = fields.Integer(allow_none=True)
    client_incident_uuid = fields.String(allow_none=True)
    safety_pin = fields.String(allow_none=True)
    reason = fields.String(allow_none=True, validate=validate.Length(max=255))
