import type { Router, Request } from 'express';
import type { Prisma } from '@prisma/client';
import type { Expand } from 'wasp/universal/types';
import type { ProviderName } from '../utils';
export declare function defineUserSignupFields(fields: UserSignupFields): UserSignupFields;
type UserEntityCreateInput = Prisma.UserCreateInput;
export type ProviderConfig = {
    id: ProviderName;
    displayName: string;
    createRouter(provider: ProviderConfig): Router;
};
export type RequestWithWasp = Request & {
    wasp?: {
        [key: string]: any;
    };
};
export type PossibleUserFields = Expand<Partial<UserEntityCreateInput>>;
export type UserSignupFields = {
    [key in keyof PossibleUserFields]: FieldGetter<PossibleUserFields[key]>;
};
type FieldGetter<T> = (data: {
    [key: string]: unknown;
}) => Promise<T | undefined> | T | undefined;
export {};
//# sourceMappingURL=types.d.ts.map