////////////////////////////////////////////////////////////////////////////////
//
//  MATTBOLT.BLOGSPOT.COM
//  Copyright(C) 2012 Matt Bolt
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at:
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////

@class FlibtyConnection;

@protocol FlibtyConnectionDelegate <NSObject>

/**
 * This method is executed when the FlibtyConnection establishes a reliable connection. This
 * would occur after the policy-file has been written. 
 */
-(void)socketDidConnect:(FlibtyConnection*)connection;

/**
 * This method is executed when the FlibtyConnection is disconnected, either by the remote peer, or
 * explicitly through the disconnect method.
 */
-(void)socketDisconnected:(FlibtyConnection*)connection;


@optional

/**
 * Optionally, this method can be used to notify the use of the policy file.
 */
-(void)policyFileSent:(FlibtyConnection*)connection;



@end
