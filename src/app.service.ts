import { Injectable, Inject } from '@nestjs/common';
import { ClientProxy } from '@nestjs/microservices';
import { CreateUserDto } from './dtos/user.dto';

@Injectable()
export class AppService {
  constructor(@Inject('USERS_SERVICE') private client: ClientProxy) {}

  createUser(user: CreateUserDto) {
    return this.client.send({ cmd: 'create_user' }, user);
  }
}
