--
-- Autogenerated by Thrift
--
-- DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
-- @generated
--


require 'Thrift'
require 'social_network_ttypes'

UniqueIdServiceClient = __TObject.new(__TClient, {
  __type = 'UniqueIdServiceClient'
})

function UniqueIdServiceClient:ComposeUniqueId(req_id, post_type, carrier)
  self:send_ComposeUniqueId(req_id, post_type, carrier)
  return self:recv_ComposeUniqueId(req_id, post_type, carrier)
end

function UniqueIdServiceClient:send_ComposeUniqueId(req_id, post_type, carrier)
  self.oprot:writeMessageBegin('ComposeUniqueId', TMessageType.CALL, self._seqid)
  local args = ComposeUniqueId_args:new{}
  args.req_id = req_id
  args.post_type = post_type
  args.carrier = carrier
  args:write(self.oprot)
  self.oprot:writeMessageEnd()
  self.oprot.trans:flush()
end

function UniqueIdServiceClient:recv_ComposeUniqueId(req_id, post_type, carrier)
  local fname, mtype, rseqid = self.iprot:readMessageBegin()
  if mtype == TMessageType.EXCEPTION then
    local x = TApplicationException:new{}
    x:read(self.iprot)
    self.iprot:readMessageEnd()
    error(x)
  end
  local result = ComposeUniqueId_result:new{}
  result:read(self.iprot)
  self.iprot:readMessageEnd()
  if result.success ~= nil then
    return result.success
  elseif result.se then
    error(result.se)
  end
  error(TApplicationException:new{errorCode = TApplicationException.MISSING_RESULT})
end
UniqueIdServiceIface = __TObject:new{
  __type = 'UniqueIdServiceIface'
}


UniqueIdServiceProcessor = __TObject.new(__TProcessor
, {
 __type = 'UniqueIdServiceProcessor'
})

function UniqueIdServiceProcessor:process(iprot, oprot, server_ctx)
  local name, mtype, seqid = iprot:readMessageBegin()
  local func_name = 'process_' .. name
  if not self[func_name] or ttype(self[func_name]) ~= 'function' then
    iprot:skip(TType.STRUCT)
    iprot:readMessageEnd()
    x = TApplicationException:new{
      errorCode = TApplicationException.UNKNOWN_METHOD
    }
    oprot:writeMessageBegin(name, TMessageType.EXCEPTION, seqid)
    x:write(oprot)
    oprot:writeMessageEnd()
    oprot.trans:flush()
  else
    self[func_name](self, seqid, iprot, oprot, server_ctx)
  end
end

function UniqueIdServiceProcessor:process_ComposeUniqueId(seqid, iprot, oprot, server_ctx)
  local args = ComposeUniqueId_args:new{}
  local reply_type = TMessageType.REPLY
  args:read(iprot)
  iprot:readMessageEnd()
  local result = ComposeUniqueId_result:new{}
  local status, res = pcall(self.handler.ComposeUniqueId, self.handler, args.req_id, args.post_type, args.carrier)
  if not status then
    reply_type = TMessageType.EXCEPTION
    result = TApplicationException:new{message = res}
  elseif ttype(res) == 'ServiceException' then
    result.se = res
  else
    result.success = res
  end
  oprot:writeMessageBegin('ComposeUniqueId', reply_type, seqid)
  result:write(oprot)
  oprot:writeMessageEnd()
  oprot.trans:flush()
end

-- HELPER FUNCTIONS AND STRUCTURES

ComposeUniqueId_args = __TObject:new{
  req_id,
  post_type,
  carrier
}

function ComposeUniqueId_args:read(iprot)
  iprot:readStructBegin()
  while true do
    local fname, ftype, fid = iprot:readFieldBegin()
    if ftype == TType.STOP then
      break
    elseif fid == 1 then
      if ftype == TType.I64 then
        self.req_id = iprot:readI64()
      else
        iprot:skip(ftype)
      end
    elseif fid == 2 then
      if ftype == TType.I32 then
        self.post_type = iprot:readI32()
      else
        iprot:skip(ftype)
      end
    elseif fid == 3 then
      if ftype == TType.MAP then
        self.carrier = {}
        local _ktype31, _vtype32, _size30 = iprot:readMapBegin()
        for _i=1,_size30 do
          local _key34 = iprot:readString()
          local _val35 = iprot:readString()
          self.carrier[_key34] = _val35
        end
        iprot:readMapEnd()
      else
        iprot:skip(ftype)
      end
    else
      iprot:skip(ftype)
    end
    iprot:readFieldEnd()
  end
  iprot:readStructEnd()
end

function ComposeUniqueId_args:write(oprot)
  oprot:writeStructBegin('ComposeUniqueId_args')
  if self.req_id ~= nil then
    oprot:writeFieldBegin('req_id', TType.I64, 1)
    oprot:writeI64(self.req_id)
    oprot:writeFieldEnd()
  end
  if self.post_type ~= nil then
    oprot:writeFieldBegin('post_type', TType.I32, 2)
    oprot:writeI32(self.post_type)
    oprot:writeFieldEnd()
  end
  if self.carrier ~= nil then
    oprot:writeFieldBegin('carrier', TType.MAP, 3)
    oprot:writeMapBegin(TType.STRING, TType.STRING, ttable_size(self.carrier))
    for kiter36,viter37 in pairs(self.carrier) do
      oprot:writeString(kiter36)
      oprot:writeString(viter37)
    end
    oprot:writeMapEnd()
    oprot:writeFieldEnd()
  end
  oprot:writeFieldStop()
  oprot:writeStructEnd()
end

ComposeUniqueId_result = __TObject:new{
  success,
  se
}

function ComposeUniqueId_result:read(iprot)
  iprot:readStructBegin()
  while true do
    local fname, ftype, fid = iprot:readFieldBegin()
    if ftype == TType.STOP then
      break
    elseif fid == 0 then
      if ftype == TType.I64 then
        self.success = iprot:readI64()
      else
        iprot:skip(ftype)
      end
    elseif fid == 1 then
      if ftype == TType.STRUCT then
        self.se = ServiceException:new{}
        self.se:read(iprot)
      else
        iprot:skip(ftype)
      end
    else
      iprot:skip(ftype)
    end
    iprot:readFieldEnd()
  end
  iprot:readStructEnd()
end

function ComposeUniqueId_result:write(oprot)
  oprot:writeStructBegin('ComposeUniqueId_result')
  if self.success ~= nil then
    oprot:writeFieldBegin('success', TType.I64, 0)
    oprot:writeI64(self.success)
    oprot:writeFieldEnd()
  end
  if self.se ~= nil then
    oprot:writeFieldBegin('se', TType.STRUCT, 1)
    self.se:write(oprot)
    oprot:writeFieldEnd()
  end
  oprot:writeFieldStop()
  oprot:writeStructEnd()
end